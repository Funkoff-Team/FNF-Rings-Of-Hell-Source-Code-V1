package videos;

#if VIDEOS_ALLOWED 
#if hxCodec
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#elseif hxvlc
import hxvlc.flixel.FlxVideo as VideoHandler;
#end
#end
import haxe.extern.EitherType;
import flixel.util.FlxSignal;

class Video extends VideoHandler
{
	@:isVar
	public var playbackRate(get, set):Float;
	public var paused(default, set):Bool = false;
	public var onVideoEnd:FlxSignal;
	public var onVideoStart:FlxSignal;

	public function new(#if ((hxCodec >= "3.0.0" && hxCodec) || hxvlc) ?autoDispose:Bool = true #end #if hxvlc ,smoothing:Bool = true #end)
	{
		super();
		onVideoEnd = new FlxSignal();
		onVideoStart = new FlxSignal();
		#if ((hxCodec >= "3.0.0" && hxCodec) || hxvlc)
		if (autoDispose)
			onEndReached.add(function()
			{
				dispose();
			}, true);
		onOpening.add(onVideoStart.dispatch);
		onEndReached.add(onVideoEnd.dispatch);
		#elseif (hxCodec < "3.0.0" && hxCodec)
		openingCallback = onVideoStart.dispatch;
		finishCallback = onVideoEnd.dispatch;
		#end
	}

	public function startVideo(path:String, loop:Bool = false #if hxvlc ,?options:Array<String> #end):Video
	{
		#if (hxCodec >= "3.0.0"  && hxCodec)
        play(path, loop);
        #elseif (hxCodec < "3.0.0"  && hxCodec)
        playVideo(path, loop, false);
        #elseif hxvlc
		if(options == null)
			options = [];
		if(loop)
			options.push(':input-repeat=2');
		else
			options.push(':input-repeat=0');
		#if android
        load(openfl.Assets.getBytes(path), options);
		#else
        load(path, options);
		#end
        play();
		#end
		return this;
	}

	@:noCompletion
	private function set_paused(shouldPause:Bool)
	{
		#if hxvlc
		if(shouldPause)
		{
			autoPause = false;
			pause();
		}
		else
		{
			autoPause = FlxG.autoPause;
			resume();
		}
		#elseif hxCodec
		if (shouldPause)
		{
			pause();
			if (FlxG.autoPause)
			{
				if (FlxG.signals.focusGained.has(pause))
					FlxG.signals.focusGained.remove(pause);

				if (FlxG.signals.focusLost.has(resume))
					FlxG.signals.focusLost.remove(resume);
			}
		}
		else
		{
			resume();
			if (FlxG.autoPause)
			{
				FlxG.signals.focusGained.add(pause);
				FlxG.signals.focusLost.add(resume);
			}
		}
		#end
		return shouldPause;
	}

	public function endVideo(){
		try {
			#if ((hxCodec >= "3.0.0" && hxCodec) || hxvlc)
			dispose();
			#elseif (hxCodec < "3.0.0" && hxCodec)
			onEndReached();
			#end
		} catch (e:Dynamic) trace('exploded: $e');
	}

	@:noCompletion
	private function set_playbackRate(multi:Float):Float
	{
		playbackRate = rate = multi;
		return multi;
	}

	@:noCompletion
	private function get_playbackRate():Float
	{
		return rate;
	}
}