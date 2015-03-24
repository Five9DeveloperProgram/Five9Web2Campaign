/*
 * Copyright (c) 2015 Five9, Inc. The content presented herein may not, under any
 * circumstances, be reproduced in whole or in any part or form without written
 * permission from Five9, Inc.
 *
 * This program is distributed in the hope that it will be useful, but without
 * any warranty. It is provided "as is" without warranty of any kind, either expressed
 * or implied, including, but not limited to, the implied warranties of merchantability
 * and fitness for a particular purpose. The entire risk as to the quality and performance
 * of the program is with you. Should the program prove defective, you assume the cost of
 * all necessary servicing, repair or correction.
 *
 */

global class F9Web2Campaign implements Database.AllowsCallouts
{
    private static String APIURL = 'https://api.five9.com/web2campaign/AddToList';

     public F9Web2CampaignResult doPost(Map<string, string> lead)
    {
        //Let PageReference class format our parameters for us.
        System.PageReference pageReference = new System.PageReference('');
        lead.put('F9retURL', 'localhost');//give it a retUrl so we can grab the url isntead of parsing the html
        lead.put('F9retResults','1');
        pageReference.getParameters().putAll(lead);

        String query = pageReference.getUrl().substring(1);//trim off the question mark
        
            // Instantiate a new http object
        Http h = new Http();
    
         // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(APIURL);
        req.setBody(query);
        req.setMethod('POST');
        //req.setCompressed(true); // otherwise we hit a limit of 32000, five9 api seems to choke on this...
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        string body = res.getBody();
        Integer statusCode = res.getStatusCode();
        Integer errCode = -1;
        String errDesc = '';
        if(statusCode == 302)
        {
            String retURLstr = res.getHeader('Location').replace('http://localhost?', '');
            List<String> temp = retURLstr.split('&',0);
            Map<String, String> params = new Map<String, String>();
            for(String v: temp)
            {
                List<String> t2 = v.split('=', 2);
                if(t2.size() > 1)
                {
                    params.put(t2[0], t2[1]);
                }
            }

            if(params.get('F9errCode')!=null)
                errCode = Integer.valueOf(params.get('F9errCode'));
            if(params.get('F9errDesc')!=null)
                errDesc = params.get('F9errDesc');

        }
        else
        {
            return new F9Web2CampaignResult(statusCode, 'Server returned error code: '+statusCode);
        }
        return new F9Web2CampaignResult(errCode, errDesc);
    }

}