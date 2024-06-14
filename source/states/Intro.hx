package states;

import sys.FileSystem;

#if VIDEOS_ALLOWED
import hxcodec.VideoHandler;
import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
    override public function create()
    {
        var video = new VideoHandler();
        video.canSkip = false;
		video.finishCallback = function()
		{
      MusicBeatState.switchState(new TitleState());
		}
		video.playVideo(Paths.video('newgroundsintro'));
    }
}

#end