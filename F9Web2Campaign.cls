global class F9Web2Campaign 
{
	private static final string APIURL = 'https://api.five9.com/web2campaign/AddToList';
	private string F9retURL = null;
	private string F9domain;
	private final Set<String> requiredParams = new Set<String> { 'F9list', 'number1'};//also F9domain
	private final Set<String> optionalParams = new Set<String> { 'F9retURL','first_name', 'last_name', 'F9TimeToCall', 'F9TimeFormat'};
	private List<Map<string, string>> queue = new List<Map<string, string>>();
	private List<Map<string, string>> rejects = new List<Map<string, string>>();

	public F9Web2Campaign(string F9domain)
	{
		this.F9domain = F9domain;
	}
	
	public F9Web2Campaign(string F9domain, string F9retURL)
	{
		this(F9domain);
		this.F9retURL = F9retURL;
	}
	
	public void addToQueue(Map<string, string> lead)
	{
		
		Set<string> lkeys = lead.keySet();
		if(!lkeys.containsAll(this.requiredParams))
		{
			throw new F9Web2CampaignException('You must include all required fields: '+this.setToString(this.requiredParams));
			return;
		}
		
		Set<string> temp = this.requiredParams.clone();
		temp.addAll(this.optionalParams);
		
		Set<string> lkeys2 = lkeys.clone();
		lkeys2.removeAll(temp);
		System.debug(lead);
		if(lkeys2.size() > 0)
		{
			throw new F9Web2CampaignException('Invalid field(s) detected: '+this.setToString(lkeys));
			return;
		}
		
		if(this.queue.size() >= 100)
		{
			throw new F9Web2CampaignException('Cannot queue more than 100 Web2Campaign requests at a time');
			return;
		}
		if(this.F9retURL != null){
			lead.put('F9retURL', this.F9retURL);
		}
		lead.put('F9domain', this.F9domain);
		System.debug(lead);
		this.queue.add(lead);
		
	}
	
	
	public void process()
	{
		for(Map<string, string> lead: this.queue)
		{

			boolean result = this.doGet(lead);
			if(result == False)
			{
				this.rejects.add(lead);	
			}
			
		}
		this.queue.clear();
		//TODO do something with the rejects
	}
	
	 private boolean doGet(Map<string, string> lead)
	{
		System.PageReference pageReference = new System.PageReference('');
		pageReference.getParameters().putAll(lead);

		String query = pageReference.getUrl();
		
		    // Instantiate a new http object
	    Http h = new Http();
	
	     // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
	    System.debug(APIURL+query);
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(APIURL+query);
	    req.setMethod('GET');
	
	    // Send the request, and return a response
	    HttpResponse res = h.send(req);
	    string body = res.getBody();
	    System.debug(body);
	    if(body.contains('name="F9errCode" value="0"'))
	    {
	    	System.debug('Lead added successfully');
	    	return true;
	    }
	    else
	    {
	    	System.debug('Lead not added');
			return false;
	    }

	}
	
	public boolean go(Map<string,string> lead)
	{
		if(this.queue.size() > 0)
		{
			throw new F9Web2CampaignException('Cannot use the go method with leads in queue');
			return false;
		}

		this.addToQueue(lead);
		this.process();
		return true;
	}

	private string setToString(Set<string> mySet)
	{
		String returnString = '';
		for(String s: mySet) 
		{
	   		returnString += (returnString==''?'':', ')+s;
		}
		return returnString;
	}
	
}