package states;

#if VIDEOS_ALLOWED
import videos.Video;
import flixel.FlxBasic;
import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
	  var cutVid:Video = new Video();

    override public function create()
    {
		cutVid.startVideo(Paths.video('newgroundsintro'));
		add(cutVid);
			cutVid.onVideoEnd.addOnce(() -> {
			 remove(cutVid);
			 MusicBeatState.switchState(new TitleState()); 
			});
    }
}
#end