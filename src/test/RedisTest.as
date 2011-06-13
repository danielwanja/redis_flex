package test
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flashx.textLayout.debug.assert;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	import redis.Redis;
	import redis.events.ResultEvent;

	/**
	 *  Before running these tests start a redis-server locally on the default port.
	 */
	public class RedisTest
	{		
		static private var server:Redis;
		
		[Before(async)]
		public function setUp():void
		{
			server = new Redis();
			Async.proceedOnEvent(this, server, "connected");
			server.connect();
		}
		
		[After]
		public function tearDown():void
		{
			server = null;
		}
		
		[Test(async)]
		public function testSetGet():void {
			Async.handleEvent(this, server, "result", assertSetGetResultStep1);
			server.send("SET A 123");
		}
		
		protected function assertSetGetResultStep1(event:ResultEvent, passThroughData:Object):void
		{
			Async.handleEvent(this, server, "result", assertSetGetResultStep2);
			assertTrue(event.result is Array);
			assertEquals(0, event.result.length);
			server.send("GET A");
		}		
		
		protected function assertSetGetResultStep2(event:ResultEvent, passThroughData:Object):void
		{
			assertTrue(event.result is Array);
			assertEquals(1, event.result.length);			
			assertEquals("123", event.result[0]);
			
		}
		
	}
}