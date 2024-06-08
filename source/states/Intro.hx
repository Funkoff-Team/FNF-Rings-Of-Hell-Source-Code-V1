package states;

#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideo;
#end

import states.TitleState;
import videos.Video;
import videos.VideoSprite;

using StringTools;

class Intro extends MusicBeatState
{

    override public function create()
    {
    var cutVid:VideoSprite;
	  cutVid = new VideoSprite();
		cutVid.scrollFactor.set(0, 0);
		cutVid.startVideo(Paths.video('newgroundsintro'));
		add(cutVid);
    cutVid.onVideoEnd.addOnce(finishVideo);
  }

	override function update(elapsed:Float)
	{
  public function finishVideo():Void
  {
		cutVid.destroy();
		remove(cutVid);
    MusicBeatState.switchState(new TitleState()); 
  }
	}
}