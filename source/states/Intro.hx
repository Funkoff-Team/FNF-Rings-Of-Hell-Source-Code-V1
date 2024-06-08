package states;

#if VIDEOS_ALLOWED
/*#if hxCodec
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#end
#else import vlc.MP4Handler as VideoHandler;
#end*/
#if hxvlc
import hxvlc.flixel.FlxVideo;
#end
#end

import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
    override public function create()
    {
		var filePath:String = Paths.video('newgroundsintro');

/*		#if hxCodec
    var video:VideoHandler = new VideoHandler();

      #if (hxCodec >= "3.0.0")
			video.play(filepath);
			video.onEndReached.add(function()
			{
				video.dispose();
       MusicBeatState.switchState(new TitleState());
			}, true);
					#else
	  	video.playVideo(filepath);
	  	video.finishCallback = function()
   		{
       MusicBeatState.switchState(new TitleState());
  }
  #end
  #end*/

  #if hxvlc
  playIntro(filePath);
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
  #end
  }

	override function update(elapsed:Float)
	{
  #if hxvlc
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
  #end
	}
}