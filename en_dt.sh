#!/bin/bash

echo '
s/Ge\. /Genesis /g
s/Gen\. /Genesis /g
s/Ex\. /Exodus /g
s/Le\. /Leviticus /g
s/Nu\. /Numbers /g
s/De\. /Deuteronomy /g
s/Jos\. /Joshua /g
s/Jg\. /Judges /g
s/Judg\. /Judges /g
s/Ru\. /Ruth /g
s/1Sa\. /First Samuel /g
s/2Sa\. /Second Samuel /g
s/1Ki\. /First Kings /g
s/2Ki\. /Second Kings /g
s/1 Ki\. /First Kings /g
s/2 Ki\. /Second Kings /g
s/1Ch\. /First Chronicles /g
s/2Ch\. /Second Chronicles /g
s/1 Chron\. /First Chronicles /g
s/2 Chron\. /Second Chronicles /g
s/Ezr\. /Ezra /g
s/Ne\. /Nehemiah /g
s/Es\. /Esther /g
s/Job\. /Job /g
s/Ps\. /Psalms /g
s/Pr\. /Proverbs /g
s/Prov\. /Proverbs /g
s/Ec\. /Ecclesiastes /g
s/Eccl\. /Ecclesiastes /g
s/Ca\. /Song of Solomon /g
s/Isa\. /Isaiah /g
s/Jer\. /Jeremiah /g
s/La\. /Lamentations /g
s/Eze\. /Ezekiel /g
s/Da\. /Daniel /g
s/Ho\. /Hosea /g
s/Joe\. /Joel /g
s/Am\. /Amos /g
s/Ob\. /Obadiah /g
s/Jon\. /Jonah /g
s/Mic\. /Micah /g
s/Na\. /Nahum /g
s/Hab\. /Habakkuk /g
s/Zep\. /Zephaniah /g
s/Hag\. /Haggai /g
s/Zec\. /Zechariah /g
s/Mal\. /Malachi /g
s/Mt\. /Matthew /g
s/Matt\. /Matthew /g
s/Mr\. /Mark /g
s/Lu\. /Luke /g
s/Joh\. /John /g
s/Ac\. /Acts /g
s/Ro\. /Romans /g
s/Rom\. /Romans /g
s/1Co\. /First Corinthians /g
s/2Co\. /Second Corinthians /g
s/1 Cor\. /First Corinthians /g
s/2 Cor\. /Second Corinthians /g
s/Ga\. /Galatians /g
s/Eph\. /Ephesians /g
s/Php\. /Philippians /g
s/Phil\. /Philippians /g
s/Col\. /Colossians /g
s/1Th\. /First Thessalonians /g
s/2Th\. /Second Thessalonians /g
s/1 Thess\. /First Thessalonians /g
s/2 Thess\. /Second Thessalonians /g
s/1Ti\. /First Timothy /g
s/2Ti\. /Second Timothy /g
s/1 Tim\. /First Timothy /g
s/2 Tim\. /Second Timothy /g
s/Tit\. /Titus /g
s/Phm\. /Philemon /g
s/Heb\. /Hebrews /g
s/Jas\. /James /g
s/1Pe\. /First Peter /g
s/2Pe\. /Second Peter /g
s/1 Pet\. /First Peter /g
s/2 Pet\. /Second Peter /g
s/1Jo\. /First John /g
s/2Jo\. /Second John /g
s/3Jo\. /Third John /g
s/Jude\. /Jude /g
s/Re\. /Revelation /g
s/¶/paragraph /g
' > ./books_replacements.sed

sayExpandedScripture()
{
  if [ "$1" ]; then
    say "$(echo $1 |tr ' ' ' '| sed -f ./books_replacements.sed)"
  fi
}

if [ "$1" ]; then
  vDATE="$1"
else
  vDATE="`date +%Y/%m/%d`"
fi
echo '
on run {theBuddyPhone, theMessage}
    tell application "Messages"
      set myid to get id of first service
      set theBuddy to buddy theBuddyPhone of service id myid
      send theMessage to theBuddy
    end tell
end run
' > ./send.scpt

curl -kL --silent "https://wol.jw.org/en/wol/dt/r1/lp-e/${vDATE}" -o ./wol.htm
grep themeScrp ./wol.htm > ./dt.htm
grep 'class="sb">' ./wol.htm > ./descr.htm
vDT="`cat ./dt.htm | awk -F 'themeScrp\">' '{print $2}'| awk -F '<a href' '{print $1}' | sed -e 's/<em>//g' -e 's/<\/em>//g'`"
vDESCR="`cat ./descr.htm | awk -F 'class="sb">' '{print $2}'| awk -F '</p>' '{print $1}' | sed -e 's/<em>//g' -e 's/<\/em>//g' | tr '<' '\n' | tr '>' '\n' | grep -v 'a href\|/a' | tr -d '\n'`"
vSCRIPTURE="`cat ./dt.htm | awk -F '<a href' '{print $2}'| awk -F '</a' '{print $1}' | awk -F '<em>' '{print $2,$3,$4,$5}' | awk  -F '<' '{print $1}'`"

echo
echo "DAILY TEXT: $vDT $vSCRIPTURE"
sayExpandedScripture "$vDT $vSCRIPTURE"
echo
echo "${vDESCR}"
sayExpandedScripture "${vDESCR}"

# enable below to send via text also
# osascript ./send.scpt "+15551234567" "$vDT $vSCRIPTURE" # person1
# osascript ./send.scpt "+15551234567" "$vDT $vSCRIPTURE" # person2

# comment below for leaving debug files
rm -rf ./wol.htm ./dt.htm ./descr.htm ./send.scpt ./books_replacements.sed
