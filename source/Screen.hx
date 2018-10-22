package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;

class Screen {
	private var screen : FlxSpriteGroup;
	private var canvas : FlxSprite;

	public function new(screen : FlxSpriteGroup) {
		this.screen = screen;

		this.canvas = new FlxSprite();
		this.canvas.makeGraphic(1920, 1080, FlxColor.TRANSPARENT, true);

		screen.add(this.canvas);

		clearBackground();
	}

	public function clearBackground() {
		this.canvas.fill(FlxColor.TRANSPARENT);
		this.canvas.drawRect(0, 0, 1920, 1080, new FlxColor(0xFF0B6623), { color : new FlxColor(0xFF41FF00), thickness : 10 }, { smoothing : true });
	}

	private function createText(x : Float, y : Float, size : Int) {
		var text : FlxText = new FlxText(x, y, 0, '', size);
		text.setFormat('assets/fonts/gladiaclm-bold-webfont.ttf', size, new FlxColor(0x41FF00));
		this.screen.add(text);
		return text;
	}

	private function setText(textControl : FlxText, text : String) {
		if (textControl.text != '') {
			textControl.x += textControl.width / 2;
			textControl.y += textControl.height / 2;
		}

		textControl.text = text;

		textControl.x -= textControl.width / 2;
		textControl.y -= textControl.height / 2;
	}
}