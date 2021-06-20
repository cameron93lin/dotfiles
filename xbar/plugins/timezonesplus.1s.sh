#!/bin/bash

# <bitbar.title>Timezones+</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Aaron Edell</bitbar.author>
# <bitbar.author.github>aaronedell</bitbar.author.github>
# <bitbar.desc>Rotates current time through four common timezones </bitbar.desc>
# <bitbar.image>http://i.imgur.com/Y4nhdZo.png</bitbar.image>
# <bitbar.dependencies>Bash GNU AWK</bitbar.dependencies>

echo -n "当地时间 " ; date +'%Y-%m-%d %H:%M'
echo "---"
echo -n "林肯时间 " ; TZ=":US/Central" date +'%Y-%m-%d %H:%M'
echo -n "广州时间 " ; TZ="Asia/Hong_Kong" date +'%Y-%m-%d %H:%M'
echo -n "东部时间 " ; TZ=":US/Eastern" date +'%Y-%m-%d %H:%M'
echo -n "西部时间 " ; TZ=":US/Pacific" date +'%Y-%m-%d %H:%M'
echo -n "伦敦 " ; TZ=":Europe/London" date +'%Y-%m-%d %H:%M'
