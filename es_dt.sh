#!/bin/bash

echo '
s/Gé\. /Génesis /g
s/Gén\. /Génesis /g
s/Éx\. /Éxodo /g
s/Le\. /Levítico /g
s/Nú\. /Números /g
s/De\. /Deuteronomio /g
s/Jos\. /Josué /g
s/Ju\. /Jueces /g
s/Jue\. /Jueces /g
s/Ru\. /Rut /g
s/1Sa\. /Primera De Samuel /g
s/2Sa\. /Segunda De Samuel /g
s/1Rey\. /Primera De Reyes /g
s/2Rey\. /Segunda De Reyes /g
s/1 Rey\. /Primera De Reyes /g
s/2 Rey\. /Segunda De Reyes /g
s/1Cr\. /Primera De Crónicas /g
s/2Cr\. /Segunda De Crónicas /g
s/1 Cró\. /Primera De Crónicas /g
s/2 Cró\. /Segunda De Crónicas /g
s/Esd\. /Esdras /g
s/Neh\. /Nehemías /g
s/Est\. /Ester /g
s/Job\. /Job /g
s/Sal\. /Salmos /g
s/Pr\. /Proverbios /g
s/Prov\. /Proverbios /g
s/Ec\. /Eclesiastés /g
s/Ecl\. /Eclesiastés /g
s/Ca\. /El Cantar de los Cantares /g
s/Isa\. /Isaías /g
s/Jer\. /Jeremías /g
s/La\. /Lamentaciones /g
s/Eze\. /Ezequiel /g
s/Da\. /Daniel /g
s/Os\. /Oseas /g
s/Joe\. /Joel /g
s/Am\. /Amós /g
s/Ab\. /Abdías /g
s/Jon\. /Jonás /g
s/Miq\. /Miqueas /g
s/Na\. /Nahúm /g
s/Hab\. /Habacuc /g
s/Sof\. /Sofonías /g
s/Ag\. /Ageo /g
s/Zac\. /Zacarías /g
s/Mal\. /Malaquías /g
s/Mt\. /Mateo /g
s/Mat\. /Mateo /g
s/Mr\. /Marcos /g
s/Mar\. /Marcos /g
s/Lu\. /Lucas /g
s/Jua\. /Juan /g
s/He\. /Hechos /g
s/Ro\. /Romanos /g
s/Rom\. /Romanos /g
s/1Co\. /Primera De Corintios /g
s/2Co\. /Segunda De Corintios /g
s/1 Cor\. /Primera De Corintios /g
s/2 Cor\. /Segunda De Corintios /g
s/Gá\. /Gálatas /g
s/Ef\. /Efesios /g
s/Fi\. /Filipenses /g
s/Fil\. /Filipenses /g
s/Col\. /Colosenses /g
s/1Te\. /Primera De Tesalonicenses /g
s/2Te\. /Segunda De Tesalonicenses /g
s/1 Tes\. /Primera De Tesalonicenses /g
s/2 Tes\. /Segunda De Tesalonicenses /g
s/1Ti\. /Primera De Timoteo /g
s/2Ti\. /Segunda De Timoteo /g
s/1 Tim\. /Primera De Timoteo /g
s/2 Tim\. /Segunda De Timoteo /g
s/Tit\. /Tito /g
s/Fil\. /Filemón /g
s/Heb\. /Hebreos /g
s/San\. /Santiago /g
s/1Pe\. /Primera De Pedro /g
s/2Pe\. /Segunda De Pedro /g
s/1 Pet\. /Primera De Pedro /g
s/2 Pet\. /Segunda De Pedro /g
s/1Ju\. /Primera De Juan /g
s/2Ju\. /Segunda De Juan /g
s/3Ju\. /Tercera De Juan /g
s/Jud\. /Judas /g
s/Ap\. /Apocalipsis /g
s/párrs. /párrafos /g
' > ./books_replacements.sed

sayExpandedScripture()
{
  if [ "$1" ]; then
    say -v Paulina "$(echo $1 |tr ' ' ' '| sed -f ./books_replacements.sed)"
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
end run' > ./send.scpt

curl -kL --silent "https://wol.jw.org/es/wol/dt/r4/lp-s/${vDATE}" -o /tmp/wol.htm
grep themeScrp /tmp/wol.htm > /tmp/dt.htm
grep 'class="sb">' /tmp/wol.htm > /tmp/descr.htm
vDT="`cat /tmp/dt.htm | awk -F '\>' '{print $3}'| awk -F '(' '{print $1}'`"
vDESCR="$(cat /tmp/descr.htm | awk -F 'class="sb">' '{print $2}'| awk -F '</p>' '{print $1}' | sed -e 's/<em>//g' -e 's/<\/em>//g' | tr '<' '\n' | tr '>' '\n' | grep -v 'a href\|/a' | tr -d '\n')"
vSCRIPTURE="`cat /tmp/dt.htm | awk -F '\>' '{print $6}'| awk -F '<' '{print $1}'`"

echo
echo "TEXTO DIARIO: $vDT $vSCRIPTURE"
sayExpandedScripture "$vDT $vSCRIPTURE"
echo
echo "${vDESCR}"
sayExpandedScripture "${vDESCR}"

# echo -n "$vDT- $vSCRIPTURE" | pbcopy
# rm -rf /tmp/wol.htm /tmp/dt.htm /tmp/descr.htm
