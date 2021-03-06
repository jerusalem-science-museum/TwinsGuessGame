package;

import flixel.FlxG;

import flixel.input.keyboard.FlxKey;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;

import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class TwinScreen extends Screen {

	private var buttonKeys : Array<FlxKey>;
	private var game : PlayState;
	private var inputActive : Bool;

	private var questionText : FlxText;
	private var textAnswers : Array<FlxText>;
	private var textAnswersNumbers : Array<FlxText>;

	private var twinIndex : Int;

	private var waitOverlay : FlxSprite;
	private var waitText : FlxText;
	private var summaryText : FlxText;

	private var selectedIndex : Null<Int>;
	private var correctIndex : Null<Int>;
	private var currAnswers : Int;

	public function new(screen : FlxSpriteGroup, config : ConfigData, twinIndex : Int, buttonKeys : Array<FlxKey>, game : PlayState) {
		super(screen, config);
		this.buttonKeys = buttonKeys;
		this.game = game;
		this.twinIndex = twinIndex;
		this.inputActive = false;
		this.selectedIndex = null;
		this.correctIndex = null;

		this.textAnswersNumbers = new Array<FlxText>();
		for (i in 0...this.config.answerPositions.length) {
			var numberText : FlxText = createText(this.config.answerPositions[i].x, 
				this.config.answerPositions[i].y - this.config.answerRectHeight / 2 - this.config.answerNumberHeight / 2, this.config.answerNumberFontSize, this.config.answerNumberTextColor);
			setText(numberText, Std.string(i + 1));
			this.textAnswersNumbers.push(numberText);
			numberText.visible = false;
		}

		this.questionText = createText(this.config.questionPosition.x, this.config.questionPosition.y, this.config.questionFontSize, this.config.questionTextColor);

		this.textAnswers = new Array<FlxText>();

		for (i in 0...this.config.answerPositions.length) {
			var text : FlxText = new FlxText(this.config.answerPositions[i].x, 
				this.config.answerPositions[i].y, this.config.answerRectWidth, '', this.config.answerFontSize);
			text.setFormat('assets/fonts/' + this.config.font, this.config.answerFontSize, new FlxColor(Std.parseInt(this.config.answerTextColor)));
			text.alignment = CENTER;
			this.screen.add(text);
			this.textAnswers.push(text);
		}

		this.summaryText = new FlxText(this.config.screenWidth / 2, this.config.screenHeight / 2,
			this.config.screenWidth, '', this.config.summaryFontSize);
		this.summaryText.setFormat('assets/fonts/' + this.config.font, this.config.summaryFontSize, new FlxColor(Std.parseInt(this.config.summaryTextColor)));
		this.summaryText.alignment = CENTER;
		this.screen.add(this.summaryText);

		this.waitOverlay = new FlxSprite();
		this.waitOverlay.makeGraphic(this.config.screenWidth, this.config.screenHeight, new FlxColor(Std.parseInt(this.config.waitBackgroundColor)));

		screen.add(this.waitOverlay);

		this.waitText = createText(this.config.waitTextPosition.x, this.config.waitTextPosition.y, this.config.waitTextFontSize, this.config.waitTextColor);

		setWaitOverlayVisibility(false);
	}

	public function presentTextQuestion(text : String, answers : Array<String>) {
		this.summaryText.visible = false;
		this.selectedIndex = null;
		this.correctIndex = null;
		this.currAnswers = answers.length;
		drawBackground();
		setWaitOverlayVisibility(false);

		setText(this.questionText, text);

		for (i in 0...this.config.answerPositions.length) {
			if (i < answers.length) {
				setText(this.textAnswers[i], answers[i]);
				this.textAnswers[i].visible = true;
			} else {
				this.textAnswers[i].visible = false;
			}
		}

		this.questionText.visible = true;

		this.inputActive = true;
	}

	public function presentWaitingScreen(text : String, clearLast : Bool) {
		if (clearLast) {
			clearBackground();
			hide(this.textAnswers);
			hide(this.textAnswersNumbers);
			this.questionText.visible = false;
		}

		this.inputActive = false;
		setText(this.waitText, text);
		setWaitOverlayVisibility(true);
	}

	public function presentSummary(ratio : Float) {
		clearBackground();
		hide(this.textAnswers);
		hide(this.textAnswersNumbers);
		this.questionText.visible = false;
		setText(this.summaryText, (new EReg(this.config.summrayPercentageToken, 'g')).replace(this.config.summaryText, Std.string(Math.round(ratio * 100))));
		this.summaryText.visible = true;
	}

	public function presentTwinAnswer(index : Int) {
		this.inputActive = false;
		this.correctIndex = index;

		setText(this.questionText, (this.correctIndex == this.selectedIndex) ? this.config.successText : this.config.failText);

		setWaitOverlayVisibility(false);
		drawBackground();
	}

	public function update() {
		if (this.inputActive) {
			for (i in 0...this.buttonKeys.length) {
				if (FlxG.keys.checkStatus(this.buttonKeys[i], JUST_PRESSED)) {
					if (i < this.currAnswers) {
						this.handleSelection(i);
					}
				}
			}
		}
	}

	public function selectionPressed(i : Int) {
		if (this.inputActive) {
			if (i < this.currAnswers) {
				this.handleSelection(i);
			}
		}
	}

	private function setWaitOverlayVisibility(visible : Bool) {
		waitOverlay.visible = visible;
		waitText.visible = visible;
	}

	private function drawBackground() {
		hide(this.textAnswersNumbers);
		clearBackground();

		for (i in 0...this.currAnswers) {
			var fillColor : FlxColor = (i == this.selectedIndex) ? new FlxColor(Std.parseInt(this.config.answerSelectedBackgroundColor)) : new FlxColor(Std.parseInt(this.config.answerBackgroundColor));

			if (this.correctIndex != null && i == this.selectedIndex && this.selectedIndex != this.correctIndex) {
				fillColor = new FlxColor(Std.parseInt(this.config.answerWrongBackgroundColor));
			}

			if (this.correctIndex != null && i == this.correctIndex) {
				fillColor = new FlxColor(Std.parseInt(this.config.answerCorrectBackgroundColor));
			}

			this.canvas.drawRect(this.config.answerPositions[i].x - this.config.answerRectWidth / 2, 
				this.config.answerPositions[i].y - this.config.answerRectHeight / 2, 
				this.config.answerRectWidth, this.config.answerRectHeight, fillColor, 
				{ color : new FlxColor(Std.parseInt(this.config.answerBorderColor)), thickness : this.config.answerBorderThickness }, { smoothing : true });
			this.canvas.drawRect(this.config.answerPositions[i].x - this.config.answerRectWidth / 2, 
				this.config.answerPositions[i].y - this.config.answerRectHeight / 2 - this.config.answerNumberHeight, 
				this.config.answerRectWidth, this.config.answerNumberHeight, fillColor,
				 { color : new FlxColor(Std.parseInt(this.config.answerBorderColor)), thickness : this.config.answerBorderThickness }, { smoothing : true });
			this.textAnswersNumbers[i].visible = true;
		}
	}

	private function handleSelection(index : Int) {
		this.inputActive = false;
		
		this.selectedIndex = index;
		this.drawBackground();
		// Mark selection answer, sound, wait a bit...

		this.game.onSelection(this.twinIndex, index);
	}

	private function hide(sprites : Array<Dynamic>) {
		setVisible(sprites, false);
	}

	private function show(sprites : Array<Dynamic>) {
		setVisible(sprites, true);
	}

	private function setVisible(sprites : Array<Dynamic>, value : Bool) {
		for (sprite in sprites) {
			sprite.visible = value;
		}
	}
}