package states;

#if VIDEOS_ALLOWED
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
    override public function create()
    {
    var video:VideoHandler = new VideoHandler();
		var filepath:String = Paths.video('newgroundsintro');

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
    }
}