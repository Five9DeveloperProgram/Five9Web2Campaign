###Instructions:
See the Web2Campaign API guide for a list of all possible flags that can be set during a W2C request from https://login.five9.com » Customer Support » Five9 U.S. Product Documentation » Programming References section » Web2Campaign. If you are in implementation with Five9 Professional Services, consult with your PS liason on which fields may be required and which may be recommended for your specific use case. Premium Support customers should reach out to their Technical Account Manager for advice.
* F9key: is usually set to salesforce_id, but not always. Certain use cases require a different field or multi-key approach.
* F9CallASAP: may need to be set if you are sending 'hot' records.
* Additional contact fields: pass all additional fields that you may wish to report, filter or sort on from within VCC.
* Be aware of the Limits for Bulk Processing section which details default restrictions on the amount of W2C submissions.
* Lastly this code sample is meant to serve purely as an *example*. In most cases it will need to be adapted to fit your particular need.

###Example Usage:
```apex
F9Web2Campaign w2c = new F9Web2Campaign('five9domain');
Map<string, string> f9lead = new Map<string, string>();
f9lead.put('F9list','listname');
f9lead.put('number1','8016665555');
f9lead.put('F9TimeToCall','2015-02-12 14:30:00.000');
f9lead.put('F9TimeFormat','yyyy-MM-dd HH:mm:ss.SSS');
boolean res = w2c.go(f9lead);
System.debug('go result: '+res);
```
