#!/bin/sh

export outD="/home/pi/Desktop"
export outFinalF="ffprobe2sql"
export outProbeF="ffprobe2json"
export infoTXT="$outD/$outProbeF.txt"
export infoSH="$outD/$outProbeF.sh"
export infoJSON="$outD/ffprobe.json"
export infoSQL="$outD/ffprobe.sql"

find /media/pi/ZUKE/MUSIC/ -type f  | sort > "$infoTXT"

##
## This is auto-increment indices example:
## Note the LINENUM=$((LINENUM+1)) syntax.
##
## export infoSHa="~/Desktop/$outProbeF.sh.a"
## export LINENUM=0
## export LINENUM=$((LINENUM+1)) && echo ], \"$LINENUM\": [ && ffprobe -v quiet -print_format json -show_format -show_streams "/media/pi/ZUKE/MUSIC/B2 CD/01 basic2 zumba - Lolita - Rumba Flamenca.mp3"
## export LINENUM=$((LINENUM+1)) && echo ], \"$LINENUM\": [ && ffprobe -v quiet -print_format json -show_format -show_streams "/media/pi/ZUKE/MUSIC/B2 CD/10 basic2 zumba - Anda Y Dime - Tango,Hip-Hop.mp3"
#sed 's|^.\+$|export LINENUM=$((LINENUM+1)) \&\& echo ], \\"$LINENUM\\": [ \&\& ffprobe -v quiet -print_format json -show_format -show_streams "&"|' $infoTXT > "$infoSHa"
#echo 'export LINENUM=0' > "$infoSH"
#cat  "$infoSHa"        >> "$infoSH"

##
## Alternatively, this won't increment indices.
## Using filepath as the key, apply sed without 
##   temporary intermediary file
##
mv -i "$infoTXT" "$infoSH"
sed -i 's/["]/\\&/g' "$infoSH"
sed -i 's/^.\+$/export probefile="&" \&\& echo \\"\$probefile\\" : \&\& ffprobe -v quiet -print_format json -show_format -show_streams "$probefile" \&\& echo ,/' "$infoSH"

sh $infoSH > $infoJSON

echo i\) ffprobe JSON is given 4 spaces in front of each non-trivial line.
echo ii\) "filepath" : {ffprobe JSON}

echo remove the last comma in the last line
 sed -i '$ s/^,$//'              $infoJSON
echo indent ffprobe JSON by 4 spaces
 sed -i 's/^.\+$/    &/' $infoJSON
echo add opening bracket at top and closed bracket at bottom
echo which makes a dict of all "filepath" : [ffprobe JSON]
 sed -i '1 i\{' $infoJSON
 sed -i '$ a\}' $infoJSON

./ffprobe2sql.py $infoJSON > $infoSQL

echo SQL file was created: $infoSQL


