package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

typedef Stats = {
	gamesNum : Int,
	averageRatio : Float
}

class StatsScreen extends Screen {

	private var groupToStats : Map<TwinGroup, Stats>;
	private var groupToTexts : Map<TwinGroup, FlxText>;

	public function new(screen : FlxSpriteGroup, config : ConfigData) {
		super(screen, config);

		var header : FlxText = createText(this.config.questionPosition.x, this.config.questionPosition.y, this.config.questionFontSize, this.config.questionTextColor);
		setText(header, this.config.statsHeaderText);

		groupToStats = new Map<TwinGroup, Stats>();
		groupToTexts = new Map<TwinGroup, FlxText>();

		createTexts();

		loadStatistics();
		renderStatistics();
	}

	public function updateStatistics(group : TwinGroup, ratio : Float) {
		trace('UPDATING STATS, GROUP: ' + group +', RATIO: ' + ratio);
		trace('OLD RATIO: ' + groupToStats[group].averageRatio + ', NUM: ' + groupToStats[group].gamesNum);
		groupToStats[group].averageRatio = (groupToStats[group].averageRatio * groupToStats[group].gamesNum + ratio) / (groupToStats[group].gamesNum + 1);
		groupToStats[group].gamesNum++;
		trace('NEW RATIO: ' + groupToStats[group].averageRatio + ', NUM: ' + groupToStats[group].gamesNum);

		renderStatistics();
		saveStatistics();
	}

	private function createTexts() {
		var currY : Int = this.config.statsFirstTextY;

		for (group in Type.allEnums(TwinGroup)) {
			var groupText : FlxText = createText(this.config.statsGroupTextX, currY, this.config.statsGroupFontSize, this.config.statsGroupTextColor);
			setText(groupText, getHeader(group));

			var valueText : FlxText = createText(this.config.statsValueTextX, currY, this.config.statsValueFontSize, this.config.statsValueTextColor);
			groupToTexts[group] = valueText;

			currY += this.config.statsYDiff;
		}
	}

	private function getHeader(twinGroup : TwinGroup) {
		if (twinGroup == IDENTICAL_BOYS) {
			return this.config.identicalBoysStatsText;
		} else if (twinGroup == IDENTICAL_GIRLS) {
			return this.config.identicalGirlsStatsText;
		} else if (twinGroup == NON_IDENTICAL_BOYS) {
			return this.config.nonIdenticalBoysStatsText;
		} else if (twinGroup == NON_IDENTICAL_GIRLS) {
			return this.config.nonIdenticalGirlsStatsText;
		} else if (twinGroup == NON_IDENTICAL_BOY_GIRL) {
			return this.config.boyGirlStatsText;
		} else if (twinGroup == NON_TWIN_BROTHERS) {
			return this.config.brothersText;
		} else {
			return this.config.notBrothersText;
		}
	}


	private function loadStatistics() {
		var content : String = sys.io.File.getContent('assets/data/stats.txt');
		var ratios : Array<String> = content.split(',')[0].split('|');
		var numbers : Array<String> = content.split(',')[1].split('|');

		var i : Int = 0;
		for (group in Type.allEnums(TwinGroup)) {
			var stats : Stats = {gamesNum: Std.parseInt(numbers[i]), averageRatio: Std.parseFloat(ratios[i])}
			groupToStats[group] = stats;
			i++;
		}
	}

	private function saveStatistics() {
		var ratios : Array<String> = new Array<String>();
		var numbers : Array<String> = new Array<String>();

		for (group in Type.allEnums(TwinGroup)) {
			ratios.push(Std.string(groupToStats[group].averageRatio));
			numbers.push(Std.string(groupToStats[group].gamesNum));
		}

		sys.io.File.saveContent('assets/data/stats.txt', ratios.join('|') + ',' + numbers.join('|'));
	}

	private function renderStatistics() {
		var highest : Float = 0;
		for (group in Type.allEnums(TwinGroup)) {
			if (groupToStats[group].averageRatio > highest) {
				highest = groupToStats[group].averageRatio;
			}
		}

		for (group in Type.allEnums(TwinGroup)) {
			groupToTexts[group].setFormat('assets/fonts/' + this.config.font, this.config.statsValueFontSize, 
				new FlxColor(Std.parseInt(groupToStats[group].averageRatio == highest ? this.config.statsHighestValueTextColor : this.config.statsValueTextColor)));
			setText(groupToTexts[group], this.config.percentageSuffixText + ' ' + Std.string(Math.round(groupToStats[group].averageRatio * 100)) + '%');
		}
	}
}