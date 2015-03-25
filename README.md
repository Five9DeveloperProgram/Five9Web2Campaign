###Instructions:
See the Web2Campaign API guide for a list of all possible flags that can be set during a W2C request from https://login.five9.com » Customer Support » Five9 U.S. Product Documentation » Programming References section » Web2Campaign. If you are in implementation with Five9 Professional Services, consult with your PS liason on which fields may be required and which may be recommended for your specific use case. Premium Support customers should reach out to their Technical Account Manager for advice.
* F9key: is usually set to salesforce_id, but not always. Certain use cases require a different field or multi-key approach.
* F9CallASAP: may need to be set if you are sending 'hot' records.
* Additional contact fields: pass all additional fields that you may wish to report, filter or sort on from within VCC.
* Be aware of the Limits for Bulk Processing section which details default restrictions on the amount of W2C submissions.
* Lastly this code sample is meant to serve purely as an *example*. In most cases it will need to be adapted to fit your particular need.

###Example Usage:
```apex
//Create a map of key => value pairs to hold the 
//parameters to send to the W2C API.
Map<String, String> f9lead = new Map<String, String>();
f9lead.put('F9domain', 'domainname');//required
f9lead.put('F9list', 'listname');//requried
f9lead.put('number1', '8015448854');//required
f9lead.put('first_name', 'Bart');
f9lead.put('last_name', 'Simpson');

//Instantiate a new F9Web2Campaign object
F9Web2Campaign f9 = new F9Web2Campaign();
//Call the doPost method with the lead
F9Web2CampaignResult res = f9.doPost(f9lead);
//Check the result, look in the documentation
//for possible error codes, errCode of 0 means success
System.debug('errCode: ' + res.errCode + ', errDesc: '+res.errDesc);
//example debug message:
//USER_DEBUG [16]|DEBUG|errCode: 0, errDesc: "The request was successfully processed"

```
