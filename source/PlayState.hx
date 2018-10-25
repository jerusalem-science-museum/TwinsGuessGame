package;

using Lambda;

import haxe.Json;
import sys.io.File;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

import flixel.input.keyboard.FlxKey;
import flixel.group.FlxSpriteGroup;

import flixel.util.FlxTimer;

import openfl.system.System;

// IMPORTANT!
//-----------
// FOR DEBUGGING, this program better runs with with HaxeFlixel 4.4.1, and:
//-------------------------------------------------------
// haxelib set openfl 3.6.1
// haxelib set lime 2.9.1
//-------------------------------------------------------
// As otherwise Neko is very slow!
//-------------------------------------------------------
// However, for production, best to use updated versions and compile to cpp!

enum State {
    BOY_GIRL_QUESTION;
    TWIN_TYPE_QUESTION;
    WAIT_FOR_CHOICE;
    WAIT_FOR_GUESS;
    WAIT_FOR_RESULT_OK;
    WAIT_FOR_GAME_OK;
}

class PlayState extends FlxState
{
    private static inline var NO_ANSWER : Int = -1;

    private var config : ConfigData;

    private var twinScreens : Array<TwinScreen>;
    private var statsScreen : StatsScreen;

    private var hits : Int;
    private var nextChooserIndex : Int;
    private var nextGuesserIndex : Int;
    private var state : State;
    private var answersMade : Int;
    private var expectedAnswers : Int;
    private var guessesMade : Int;
    private var currIdentityQuestion : Int;

    private var currAnswers : Array<Int>;

    private var isFirstBoy : Bool;
    private var isSecondBoy : Bool;
    private var twinType : Int;

    private var twinGroup : TwinGroup;

    override public function create() : Void {
        super.create();

        currAnswers = new Array<Int>();
        currAnswers.push(NO_ANSWER);
        currAnswers.push(NO_ANSWER);

        this.config = Json.parse(File.getContent("assets/data/config.json"));

        var firstTwinSpriteGroup : FlxSpriteGroup = new FlxSpriteGroup(0, 0);
        var secondTwinSpriteGroup : FlxSpriteGroup = new FlxSpriteGroup(1920, 0);
        var statsSpriteGroup : FlxSpriteGroup = new FlxSpriteGroup(1920 * 2, 0);

        add(firstTwinSpriteGroup);
        add(secondTwinSpriteGroup);
        add(statsSpriteGroup);

        var firstTwinScreen : TwinScreen = new TwinScreen(firstTwinSpriteGroup, this.config, 0, [FlxKey.ONE, FlxKey.TWO, FlxKey.THREE, FlxKey.FOUR], this);
        var secondTwinScreen : TwinScreen = new TwinScreen(secondTwinSpriteGroup, this.config, 1, [FlxKey.SIX, FlxKey.SEVEN, FlxKey.EIGHT, FlxKey.NINE], this);
        twinScreens = new Array<TwinScreen>();
        twinScreens.push(firstTwinScreen);
        twinScreens.push(secondTwinScreen);

        statsScreen = new StatsScreen(statsSpriteGroup, this.config);

        startGame();
    }

    override public function onFocusLost() : Void {
    }

    override public function onFocus() : Void {
    }

    override public function update(elapsed : Float) : Void {
        super.update(elapsed);

        for (screen in this.twinScreens) {
            screen.update();
        }

        if (FlxG.keys.enabled && FlxG.keys.pressed.ESCAPE) {
            System.exit(0);
        }
    }

    public function onSelection(index : Int, answer : Int) {
        answersMade++;
        currAnswers[index] = answer;

        if (answersMade == expectedAnswers) {
            new FlxTimer().start(this.state == WAIT_FOR_GUESS ? 4 : 3, function(timer) { nextState(); }, 1);
        } else {
            showWaitScreen(index);
        }

        SoundUtils.playSound(SoundUtils.ITEM_SELECTED_SOUND);

        if (this.state == WAIT_FOR_CHOICE || this.state == WAIT_FOR_GUESS) {
            SoundUtils.stopMusic();
        }
    }

    public function nextState() {
        trace("NEXT STATE CALLED");

        if (state == BOY_GIRL_QUESTION) {
            processBoyGirl();
            state = TWIN_TYPE_QUESTION;
            showIdentityQuestion();
        } else if (state == TWIN_TYPE_QUESTION) {
            processTwinType();
            switchGuesser();
            state = WAIT_FOR_CHOICE;
            showNextGuessQuestion();
        } else if (state == WAIT_FOR_CHOICE) {
            state = WAIT_FOR_GUESS;
            showNextGuess();
            showGuessWaitingScreen();
            SoundUtils.playMusic(SoundUtils.GUESS_MUSIC);
        } else if (state == WAIT_FOR_GUESS) {
            evaluateHit();
            state = WAIT_FOR_RESULT_OK;
            new FlxTimer().start(5, function(timer) { nextState(); }, 1);
        } else if (state == WAIT_FOR_RESULT_OK) {
            this.guessesMade++;
            trace("GUESSES: " + this.guessesMade);
            if (guessesMade == this.config.guessQuestions.length) {
                // TODO: Show summary screen for both twins
                var ratio : Float = this.hits / this.guessesMade;
                this.twinScreens[this.nextGuesserIndex].presentSummary(ratio);
                this.twinScreens[this.nextChooserIndex].presentSummary(ratio);
                state = WAIT_FOR_GAME_OK;
                statsScreen.updateStatistics(this.twinGroup, this.hits / this.guessesMade);
                new FlxTimer().start(5, function(timer) { nextState(); }, 1);
            } else {
                switchGuesser();
                state = WAIT_FOR_CHOICE;
                showNextGuessQuestion();
                SoundUtils.playMusic(SoundUtils.CHOOSE_MUSIC);
            }
        } else if (state == WAIT_FOR_GAME_OK) {
            startGame();
        }
    }

    private function evaluateHit() {
        if (this.currAnswers[this.nextGuesserIndex] == this.currAnswers[this.nextChooserIndex]) {
            SoundUtils.playSound(SoundUtils.CORRECT_ANSWER_SOUND);
            this.hits++;
        } else {
            SoundUtils.playSound(SoundUtils.WRONG_ANSWER_SOUND);
        }

        this.twinScreens[this.nextGuesserIndex].presentTwinAnswer(this.currAnswers[this.nextChooserIndex]);
        this.twinScreens[this.nextChooserIndex].presentTwinAnswer(this.currAnswers[this.nextGuesserIndex]);
    }

    private function startGame() {
        this.hits = 0;
        this.nextChooserIndex = 0;
        this.nextGuesserIndex = 1;
        this.guessesMade = 0;
        this.currIdentityQuestion = 0;
        
        state = BOY_GIRL_QUESTION;
        showIdentityQuestion();
        SoundUtils.playMusic(SoundUtils.CHOOSE_MUSIC);
    }

    private function showNextGuessQuestion() {
        clearAnswers();
        showNextChoice();
        showChoiceWaitingScreen();
    }

    private function clearAnswers() {
        answersMade = 0;
        currAnswers[0] = NO_ANSWER;
        currAnswers[1] = NO_ANSWER;
    }

    private function switchGuesser() {
        this.nextChooserIndex = getOtherIndex(this.nextChooserIndex);
        this.nextGuesserIndex = getOtherIndex(this.nextGuesserIndex);
    }

    private function getOtherIndex(index : Int) {
        return (index + 1) % 2;
    }

    private function showIdentityQuestion() {
        clearAnswers();
        this.expectedAnswers = 2;
        var question : IdentityQuestion = this.config.identityQuestions[this.currIdentityQuestion];
        for (screen in this.twinScreens) {
            screen.presentTextQuestion(question.questionText, question.answerTexts);
        }

       this.currIdentityQuestion++;
    }

    private function getGuessQuestion() {
        return this.config.guessQuestions[this.guessesMade];
    }

    private function showNextChoice() {
        this.answersMade = 0;
        this.expectedAnswers = 1;
        this.twinScreens[this.nextChooserIndex].presentTextQuestion(getGuessQuestion().chooseText, getGuessQuestion().answerTexts);
    }

    private function showChoiceWaitingScreen() {
        this.twinScreens[this.nextGuesserIndex].presentWaitingScreen(this.config.chooseWaitText, true);
    }

    private function showNextGuess() {
        this.answersMade = 0;
        this.expectedAnswers = 1;
        this.twinScreens[this.nextGuesserIndex].presentTextQuestion(getGuessQuestion().guessText, getGuessQuestion().answerTexts);
    }

    private function showGuessWaitingScreen() {
        this.twinScreens[this.nextChooserIndex].presentWaitingScreen(this.config.guessWaitText, false);
    }  

    private function processBoyGirl() {
        this.isFirstBoy = (this.currAnswers[0] == this.config.boyAnswerNumber - 1);
        this.isSecondBoy = (this.currAnswers[1] == this.config.boyAnswerNumber - 1);
    }

    private function showWaitScreen(index : Int) {
        this.twinScreens[index].presentWaitingScreen(this.config.identityWaitText, false);
    }

    private function processTwinType() {
        this.twinType = currAnswers[0];
        
        if (this.twinType == this.config.identicalTwinAnswerNumber - 1) {
            if (this.isFirstBoy) {
                this.twinGroup = IDENTICAL_BOYS;
            } else {
                this.twinGroup = IDENTICAL_GIRLS;
            }
        } else if (this.twinType == this.config.nonIdenticalTwinsAnswerNumber - 1) {
            if (this.isFirstBoy && this.isSecondBoy) {
                this.twinGroup = NON_IDENTICAL_BOYS;
            } else if (!this.isFirstBoy && !this.isSecondBoy) {
                this.twinGroup = NON_IDENTICAL_GIRLS;
            } else {
                this.twinGroup = NON_IDENTICAL_BOY_GIRL;
            }
        } else if (this.twinType == this.config.brothersAnswerNumber - 1) {
            this.twinGroup = NON_TWIN_BROTHERS;
        } else {
            this.twinGroup = NOT_BROTHERS;
        }

        trace('TWIN TYPE: ' + this.twinType + ', IS FIRST BOY: ' + this.isFirstBoy + ', IS SECOND BOY: ' + this.isSecondBoy + ', GROUP: ' + this.twinGroup);
    }
}
