# redis_flex_ - An ActionScript Library to integrate with Redis

A minimalist Flex/ActionScript Library that allows to interact with redis, an advanced key-value store. See http://redis.io/


### Installing redis

The easiest way on your mac is using homebrew:

```
  $ brew install redis
```

Check default redis configuration in /usr/local/etc/redis.conf

### redis basics

You can use the redis client from the console:

```
	$ redis-cli
	redis> set mykey myvalue
	OK
	redis> get mykey
	"myvalue"
	redis> set mykey 123
	OK
	redis> get mykey
	"123"
	redis> del mykey
	(integer) 1
	redis> get mykey
	(nil)
```

Redis has a lot to offer as you can see at http://redis.io/commands, it provide sets, sorted sets, counters, lists, publish-subscribe, and much more.

### Why minimalist?

Rather than making strongly typed object for each command the "redis_flex" library is just a convenient wrapper to interact with Redis. The Redis class provides a _send_ method to which you pass the same string you would on the command line, i.e.

```javascript
	server.send("SET MYKEY 123")
```

You declare a connection to a redis server by creating an instance of the _redis.Redis_ class as follows: 

```XML
	<redis:Redis id="server"
	             connected="server_connectedHandler(event)"
	             result="server_resultHandler(event)" />
```

Then you can invoke the _send_ method and you will get an instance of a _redis.events.ResultEvent_ in return which can contain zero or more results based on the operation.

```javascript
	  import redis.events.ResultEvent;
	  private function setup():void {
	    server.connect();
	  }
	  protected function server_connectedHandler(event:Event):void
	  {
	    server.send("GET A");
	  }      
	  protected function server_resultHandler(event:ResultEvent):void
	  {
	    trace("RESULT:"+event.result[0]);   
	  }
```

### Security 

Note it's not a good idea to connect a Flex application directly to Redis. Redis is usually used in the context of an application server that protects it's access in the same way that Flex doesn't connect directly to a database.

