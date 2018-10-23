package;

typedef Position = {
	x : Int,
	y : Int
}

typedef GuessQuestion = {
	chooseText : String,
	guessText : String,
	answerImages : Array<String>
}

typedef ConfigData = {
	screenWidth : Int,
	screenHeight : Int,

	answerPositions : Array<Position>,
	questionPosition : Position,
	waitTextPosition : Position,

	answerRectHeight : Int,
	answerRectWidth : Int,
	answerNumberHeight : Int,

	backgroundColor : String,
	waitBackgroundColor : String,
	borderColor : String,
	questionTextColor : String,
	answerBorderColor : String,
	answerTextColor : String,
	waitTextColor : String,
	answerBackgroundColor : String,
	answerSelectedBackgroundColor : String,
	answerCorrectBackgroundColor : String,
	answerWrongBackgroundColor : String,
	answerNumberTextColor : String,
	statsGroupTextColor : String,
	statsValueTextColor : String,
	statsHighestValueTextColor : String,

	answerBorderThickness : Int,
	screenBorderThickness : Int,

	questionFontSize : Int,
	answerFontSize : Int,
	waitTextFontSize : Int,
	answerNumberFontSize : Int,
	statsGroupFontSize : Int,
	statsValueFontSize : Int,

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