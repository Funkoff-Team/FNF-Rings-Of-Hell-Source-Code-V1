package backend.animation;

import flixel.animation.FlxAnimationController;
import flixel.graphics.frames.FlxFrame;

class PsychAnimationController extends FlxAnimationController {
    public var followGlobalSpeed:Bool = true;

    public override function update(elapsed:Float):Void {
		if (_curAnim != null) {
            var speed:Float = timeScale;
            if (followGlobalSpeed) speed *= FlxG.animationTimeScale;
			_curAnim.update(elapsed * speed);
		}
		else if (_prerotated != null) {
			_prerotated.angle = _sprite.angle;
		}
	}

	override function findByPrefix(animFrames:Array<FlxFrame>, prefix:String, logError = true):Void
	{
		if (_sprite.frames != null){
			for (frame in _sprite.frames.frames)
			{
				if (frame.name != null && frame.name.startsWith(prefix))
				{
					animFrames.push(frame);
				}
			}
			
			// prevent and log errors for invalid frames
			final invalidFrames = removeInvalidFrames(animFrames);
			#if FLX_DEBUG
			if (invalidFrames.length == 0 || !logError)
				return;
			
			final names = invalidFrames.map((f)->'"${f.name}"').join(", ");
			FlxG.log.error('Attempting to use frames that belong to a destroyed graphic, frame names: $names');
			#end	
		}
	}
}