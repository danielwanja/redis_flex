package redis.events
{
  import flash.events.Event;
  
  public class ResultEvent extends Event
  {
    public var result:Object;
    public function ResultEvent(result:Object)
    {
      super("result", false, false);
      this.result = result;
    }
  }
}