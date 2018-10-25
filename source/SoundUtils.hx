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
        return FlxG.sound.play("assets/sounds/" + name + getSuffix(), volume, shouldLoop, null, true, onComplete);
        //return null;
	}


	public static function playMusic(name : String) {
	    FlxG.sound.playMusic("assets/sounds/" + name + getSuffix(), 1, true);
	}

	public static function stopMusic() {
		FlxG.sound.music.stop();
	}

	private static function getSuffix() : String {
		return ".ogg";
	}
}
