#!/bin/bash
# <bitbar.title>Nightscout Reader</bitbar.title>
# <bitbar.version>0.0.1</bitbar.version>
# <bitbar.author>Jeremy Hay Draude</bitbar.author>
# <bitbar.desc>Display current Nightscout Blood Sugar and Trend</bitbar.desc>
# <bitbar.dependencies>bash, curl, bc</bitbar.dependencies>
# <bitbar.author.github>badgerpapa</bitbar.author.github>
# <bitbar.image>https://raw.githubusercontent.com/badgerpapa/NightscoutBitBar/master/Preview.png</bitbar.image>
# <bitbar.abouturl>https://github.com/badgerpapa/NightscoutBitBar/blob/master/README.md</bitbar.abouturl>

NSURL=http://YOURNIGHTSCOUTURL.herokuapp.com
USEMMOL=true


CURRENTRESULT=$(curl --silent $NSURL/api/v1/entries/current)
RESULTARRAY=($CURRENTRESULT)

TIMESTAMP=${RESULTARRAY[0]}
TIMESTAMP=${TIMESTAMP//\.[0-9][0-9][0-9]/}
EPOCHTS=`date -j -f "%FT%T%z" $TIMESTAMP +%s`
EPOCHNOW=`date +%s`
TIMEDIFF=`echo "($EPOCHNOW - $EPOCHTS)/(60)" | bc`

BG=${RESULTARRAY[2]}
if $USEMMOL ; then
	BG=`echo "scale=1; $BG / 18" | bc`
fi


case ${RESULTARRAY[3]} in
	FortyFiveUp)
		TREND="/"
		;;
	FortyFiveDown)
		TREND="\"
		;;
	SingleUp)
		TREND="/\"
		;;
	SingleDown)
		TREND="\/"
		;;
	Flat)
		TREND="->"
		;;
	DoubleUp)
		TREND="//\\"
		;;
	DoubleDown)
		TREND="\\//"
		;;
	*)
		TREND==${RESULTARRAY[3]}
		;;
esac

echo "$BG $TREND ($TIMEDIFF m ago)"
echo "---"
echo "Go to Nightscout | href=$NSURL"
echo "Reading taken: $TIMESTAMP"
