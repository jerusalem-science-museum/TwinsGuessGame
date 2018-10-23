package;

import flixel.FlxG;
import flixel.system.FlxSound;

class SoundUtils {
	public static var ITEM_SELECTED_SOUND : String = "select-answer";
	public static var WRONG_ANSWER_SOUND : String = "wrong-answer";
	public static var CORRECT_ANSWER_SOUND : String = "correct-answer";

	public static var CHOOSE_MUSIC : String = "choose-music";
	public static var GUESS_MUSIC : String = "guess-music";

	public static function playSound(name : String, volume : Float = 1, shouldLoop : Bool = false, ?onComplete : Void -> Void) : FlxSound {
        return FlxG.sound.play("assets/sounds/" + name + SoundUtils.getSuffix(), volume, shouldLoop, null, true, onComplete);
	}

	public static function playMusic(name : String) {
		if (FlxG.sound.music != null) {
			FlxG.sound.music.stop();
		}

	    FlxG.sound.playMusic("assets/sounds/" + name + SoundUtils.getSuffix(), 1, true);
	}

	private static function getSuffix() : String {
		return ".ogg";
	}
}
