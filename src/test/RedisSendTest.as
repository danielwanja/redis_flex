package test
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flashx.textLayout.debug.assert;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.hasItems;
	
	import redis.Redis;
	import redis.events.ResultEvent;

	/**
	 *  Before running these tests start a redis-server locally on the default port.
	 */
	public class RedisSendTest
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
		
		//---------------------------------------------------------------------
		
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

		//---------------------------------------------------------------------
		
		private var messageCounter:Number = 0;  // Find better way to deal with bulk commands callbacks
		[Test(async)]
		public function testList():void {
			sendBulkCommands(["del messages",
							 ["rpush", "messages", "message one"],
							 ["rpush", "messages", "message two"],
							 ["rpush", "messages", "message three"]
							 ],
							assertListResultStep1)
		}		
		
		private function sendBulkCommands(commands:Array, completeHandler:Function):void {
			for (var i:int = 0; i < commands.length; i++) 
			{
				server.send(commands[i]);
				Async.handleEvent(this, server, "result", completeHandler, 500, messageCounter);
			}
			messageCounter = commands.length;
		}
		private function assertListResultStep1(event:ResultEvent, passThroughData:Object):void
		{
			if (--messageCounter > 0) return;
			Async.handleEvent(this, server, "result", assertListResultStep2);
			server.send("lrange messages 0 2");
		}
		
		protected function assertListResultStep2(event:ResultEvent, passThroughData:Object):void
		{
			assertTrue(event.result is Array);
			assertEquals(3, event.result.length);
			assertThat(event.result, hasItems("message one", "message two", "message three"));
		}		
	}
}