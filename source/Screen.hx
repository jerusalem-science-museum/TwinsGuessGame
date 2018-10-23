package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;

class Screen {
	private var screen : FlxSpriteGroup;
	private var canvas : FlxSprite;
	private var config : ConfigData;

	public function new(screen : FlxSpriteGroup, config : ConfigData) {
		this.screen = screen;
		this.config = config;

		this.canvas = new FlxSprite();
		this.canvas.makeGraphic(this.config.screenWidth, this.config.screenHeight, FlxColor.TRANSPARENT, true);

		screen.add(this.canvas);

		clearBackground();
	}

	public function clearBackground() {
		this.canvas.fill(FlxColor.TRANSPARENT);
		this.canvas.drawRect(0, 0, this.config.screenWidth, this.config.screenHeight, 
			new FlxColor(Std.parseInt(this.config.backgroundColor)), 
			{ color : new FlxColor(Std.parseInt(this.config.borderColor)), thickness : this.config.answerBorderThickness }, { smoothing : true });
	}

	private function createText(x : Float, y : Float, size : Int, color : String) {
		var text : FlxText = new FlxText(x, y, 0, '', size);
		text.setFormat('assets/fonts/gladiaclm-bold-webfont.ttf', size, new FlxColor(Std.parseInt(color)));
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