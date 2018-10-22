package;

import flixel.FlxG;

import flixel.input.keyboard.FlxKey;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;

import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class TwinScreen extends Screen {

	private static var RECT_HEIGHT : Int = 300;
	private static var RECT_WIDTH : Int = 300;
	private static var NUMBER_HEIGHT : Int = 50;

	private static var ANSWERS_POSITIONS = [
		{x: 1920 / 4, y : 1080 / 3},
		{x: 1920 * 3 / 4, y: 1080 / 3},
		{x: 1920 / 4, y: 1080 * 2 / 3},
		{x: 1920 * 3 / 4, y: 1080 * 2 / 3}
	];

	private var buttonKeys : Array<FlxKey>;
	private var game : PlayState;
	private var inputActive : Bool;

	private var questionText : FlxText;
	private var textAnswers : Array<FlxText>;
	private var imageAnswers : Array<FlxSprite>;
	private var imageAnswersNumbers : Array<FlxText>;

	private var twinIndex : Int;

	private var waitOverlay : FlxSprite;
	private var waitText : FlxText;

	public function new(screen : FlxSpriteGroup, twinIndex : Int, buttonKeys : Array<FlxKey>, game : PlayState) {
		super(screen);
		this.buttonKeys = buttonKeys;
		this.game = game;
		this.twinIndex = twinIndex;
		this.inputActive = false;

		this.questionText = createText(1920 / 2, 60, 60);

		this.textAnswers = new Array<FlxText>();

		this.textAnswers.push(createText(1920 / 4, 1080 / 3, 42));
		this.textAnswers.push(createText(1920 * 3 / 4, 1080 / 3, 42));
		this.textAnswers.push(createText(1920 / 4, 1080 * 2 / 3, 42));
		this.textAnswers.push(createText(1920 * 3 / 4, 1080 * 2 / 3, 42));

		this.imageAnswers = new Array<FlxSprite>();

		this.waitOverlay = new FlxSprite();
		this.waitOverlay.makeGraphic(1920, 1080, new FlxColor(0xAAFFFFFF));

		screen.add(this.waitOverlay);

		this.waitText = createText(1920 / 2, 1080 / 2, 60);

		setWaitOverlayVisibility(false);
	}

	public function presentTextQuestion(text : String, answers : Array<String>) {
		drawBackground(answers.length);
		setWaitOverlayVisibility(false);
		hide(this.imageAnswers);

		setText(this.questionText, text);

		for (i in 0...answers.length) {
			setText(this.textAnswers[i], answers[i]);
		}

		show(this.textAnswers);

		this.inputActive = true;
	}

	public function presentImageQuestion(text : String, images : Array<FlxSprite>) {
		setWaitOverlayVisibility(false);
		hide(this.textAnswers);

		setText(this.questionText, text);

		//TODO: Destroy properly
		this.imageAnswers = [];
		for (i in 0...images.length) {
			images[i].x = ANSWERS_POSITIONS[i].x;
			images[i].y = ANSWERS_POSITIONS[i].y;
			this.imageAnswers.push(images[i]);
			screen.add(images[i]);
		}

		show(this.imageAnswers);
		this.questionText.visible = true;

		this.inputActive = true;
	}

	public function presentWaitingScreen(text : String, clearLast : Bool) {
		if (clearLast) {
			hide(this.imageAnswers);
			hide(this.textAnswers);
			this.questionText.visible = false;
		}

		this.inputActive = false;
		setText(this.waitText, text);
		setWaitOverlayVisibility(true);
	}

	public function presentTwinAnswer(index : Int, isCorrect : Bool) {
		this.inputActive = false;
		setWaitOverlayVisibility(false);

		// Render answer in green if correct, or red if not correct
	}

	public function update() {
		if (this.inputActive) {
			for (i in 0...this.buttonKeys.length) {
				if (FlxG.keys.checkStatus(this.buttonKeys[i], JUST_PRESSED)) {
					this.handleSelection(i);
				}
			}
		}
	}

	private function setWaitOverlayVisibility(visible : Bool) {
		waitOverlay.visible = visible;
		waitText.visible = visible;
	}

	private function drawBackground(questionsNum : Int) {
		clearBackground();
		for (i in 0...questionsNum) {
			this.canvas.drawRect(ANSWERS_POSITIONS[i].x - RECT_WIDTH / 2, ANSWERS_POSITIONS[i].y - RECT_HEIGHT / 2, RECT_WIDTH, RECT_HEIGHT, new FlxColor(0xFF0B6623), { color : new FlxColor(0xFF41FF00), thickness : 10 }, { smoothing : true });
		}
	}

	private function handleSelection(index : Int) {
		trace("SELECTED: " + index);
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