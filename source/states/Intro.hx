package states;

#if VIDEOS_ALLOWED
import videos.Video;

import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
	  var cutVid:Video = new Video();

    override public function create()
    {
		cutVid.startVideo(Paths.video('newgroundsintro'));
		add(cutVid);
    cutVid.onVideoEnd.addOnce(finishVideo());
 
  function finishVideo()
  {
		remove(cutVid);
    MusicBeatState.switchState(new TitleState()); 
  }
    }
}
#end