# Five9Web2Campain
APEX wrapper for Five9 Web2Campaign API.

Example Usage:
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
