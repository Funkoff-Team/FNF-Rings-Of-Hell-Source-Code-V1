package states;

#if VIDEOS_ALLOWED
import videos.Video;

import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{

    override public function create()
    {
    var cutVid:VideoSprite;
	  cutVid = new Video();
		cutVid.startVideo(Paths.video('newgroundsintro'));
		add(cutVid);
    cutVid.onVideoEnd.addOnce(finishVideo);
  function finishVideo():Void
  {
		cutVid.destroy();
		remove(cutVid);
    MusicBeatState.switchState(new TitleState()); 
  }
    }
}
#end