package;

using Lambda;

import haxe.Json;
import sys.io.File;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

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

class PlayState extends FlxState
{
    override public function create() : Void {
        super.create();

        var firstText = new FlxText(1920 / 2, 1080 / 2, 0, "Screen 1", 12);
        add(firstText);

        var secondText = new FlxText(1920 / 2 + 1920, 1080 / 2, 0, "Screen 2", 12);
        add(secondText);

        var thirdText = new FlxText(1920 / 2 + (1920 * 2), 1080 / 2, 0, "Screen 3", 12);
        add(thirdText);
    }

    override public function onFocusLost() : Void {
    }

    override public function onFocus() : Void {
    }

    override public function update(elapsed : Float) : Void {
        super.update(elapsed);

        if (FlxG.keys.enabled && FlxG.keys.pressed.ESCAPE) {
            System.exit(0);
        }
    }
}
