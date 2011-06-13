package test
{
	import flashx.textLayout.debug.assert;
	
	import org.flexunit.asserts.assertEquals;
	
	import redis.Redis;

	public class RedisTest
	{		
		
		private var server:Redis;
		
		[Before]
		public function setUp():void
		{
			server = new Redis;
		}
		
		[After]
		public function tearDown():void
		{
			server = null;
		}
		
		[Test]
		public function testSimpleEncoding():void {
			assertEquals("*2\r\n$3\r\nGET\r\n$3\r\nABC\r\n", server.encode("GET ABC"));
			assertEquals("*2\r\n$3\r\nGET\r\n$11\r\nABC DEF GHI\r\n", server.encode(["GET", "ABC DEF GHI"])); 
		}
		[Test]
		public function testEncodeQuotedValue():void {
			
		}
		

		
		
	}
}