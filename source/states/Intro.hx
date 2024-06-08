package states;

#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideo;
#end

import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
    override public function create()
    {
	var filePath:String = Paths.video('newgroundsintro');
  var intro:FlxVideo = new FlxVideo();
  function playIntro(filePath:String) {
    // Video displays OVER the FlxState.

    if (intro != null)
    {
      intro.onEndReached.add(onIntroEnd);
      add(intro);

      openfl.Assets.loadBytes(filePath).onComplete(function(bytes:openfl.utils.ByteArray):Void
      {
        if (intro.load(bytes))
          intro.play();
      });
    }
    else
    {
      trace('ALERT: Video is null! Could not play cutscene!');
    }
  }
  playIntro(filePath);
  }

	override function update(elapsed:Float)
	{
  function onIntroEnd():Void
  {
    if (intro != null)
    {
      intro.stop();
      remove(intro);
    }
    intro.destroy();
    intro = null;
    MusicBeatState.switchState(new TitleState()); 
  }
	}
}