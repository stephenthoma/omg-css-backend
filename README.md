Backend
======

###Setup:

Install node and mongodb, then run:
``` bash
  $ npm install && bower install
  $ mongod
  $ cp config/default.json.sample config/default.json
```

###Run Server:

``` bash
  $ gulp #development mode
  $ gulp --production #production mode
```
