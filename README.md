# Moment Timezone Micro

Tiny module for date format and timezone conversion with Daylight Saving Time support. 

Created from [moment](https://github.com/moment/moment) and [moment-timezone](https://github.com/moment/moment-timezone).

Timezone conversion is done using as input a timezone data string.

This strings are available in moment-time module. 

They can be found at https://github.com/moment/moment-timezone/blob/develop/data/packed/latest.json

```js
var moment = require('moment-timezone-micro');
var timezone = new moment.Timezone("Etc/UTC|UTC|0|0|");
moment.format(Date.now(), "MM/DD/YYYY HH:mm:ss.SSS Z", timezone);
```

This timezone string can be supplied to a lightweigth client on setting params or fetched from a server running complete moment-timezone with all timezone database available.

### TODO:
* Example showing how to get timezone data string from moment-timezone programatically
* Implement parsing if do not increase too much the module size
