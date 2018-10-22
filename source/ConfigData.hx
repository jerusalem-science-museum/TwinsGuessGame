package;

typedef GuessQuestion = {
	chooseText : String,
	guessText : String,
	answerImages : Array<String>
}

typedef ConfigData = {
	boyAnswerNumber : Int,

	identicalTwinAnswerNumber : Int,
	nonIdenticalTwinsAnswerNumber : Int,
	brothersAnswerNumber : Int,

	identicalBoysStatsText : String,
	identicalGirlsStatsText : String,
	nonIdenticalBoysStatsText : String,
	nonIdenticalGirlsStatsText : String,
	boyGirlStatsText : String,
	brothersText : String,
	notBrothersText : String,

	statsGroupTextX : Int,
	statsValueTextX : Int,
	statsFirstTextY : Int,
	statsYDiff : Int,

	percentageSuffixText : String,

	chooseWaitText : String,
	guessWaitText : String,
	identityWaitText : String,

	identityQuestions: Array<IdentityQuestion>,
	guessQuestions: Array<GuessQuestion>
}