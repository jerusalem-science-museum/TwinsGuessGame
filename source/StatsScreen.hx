package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

typedef Stats = {
	gamesNum : Int,
	averageRatio : Float
}

class StatsScreen extends Screen {

	private var groupToStats : Map<TwinGroup, Stats>;
	private var config : ConfigData;
	private var groupToTexts : Map<TwinGroup, FlxText>;

	public function new(screen : FlxSpriteGroup, config : ConfigData) {
		super(screen);
		this.config = config;

		groupToStats = new Map<TwinGroup, Stats>();
		groupToTexts = new Map<TwinGroup, FlxText>();

		createTexts();

		loadStatistics();
		renderStatistics();
	}

	public function updateStatistics(group : TwinGroup, ratio : Float) {
		groupToStats[group].averageRatio = (groupToStats[group].averageRatio * groupToStats[group].gamesNum + ratio) / (groupToStats[group].gamesNum + 1);
		groupToStats[group].gamesNum++;

		// Update statistics

		renderStatistics();
		saveStatistics();
	}

	private function createTexts() {
		var currY : Int = this.config.statsFirstTextY;

		for (group in Type.allEnums(TwinGroup)) {
			var groupText : FlxText = createText(this.config.statsGroupTextX, currY, 42);
			setText(groupText, getHeader(group));

			var valueText : FlxText = createText(this.config.statsValueTextX, currY, 42);
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
		// Save statistics to file
	}

	private function renderStatistics() {
		for (group in Type.allEnums(TwinGroup)) {
			setText(groupToTexts[group], this.config.percentageSuffixText + ' ' + Std.string(groupToStats[group].averageRatio * 100) + '%');
		}
	}
}