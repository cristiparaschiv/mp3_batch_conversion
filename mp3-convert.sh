#!/bin/bash

# MP3 batch conversion tool
# Author: Cristi Paraschiv

FOLDER=`pwd`

usage() {
	cat << EOF
	usage: $0 <options>
	
	OPTIONS:
		-h	Show this message
		-b	Set output bitrate
EOF
}

while getopts b:h name
do
	case $name in
		b)	bitrate=$OPTARG;;
		h)	usage
			exit 1
			;;
	esac
done

if [[ ! $bitrate ]]
then
	usage
	exit 1
fi

PART=`date +"%s"`
FILE="$HOME/mp3-convert_$PART.log"

for f in *.mp3
do
	if [ -f "$f" ]; then
		echo "Starting new conversion" >>$FILE
		echo "    Converting $f" >>$FILE
		SONG=`id3ed -i "$f" | grep songname | sed 's/songname: //'`
		ARTIST=`id3ed -i "$f" | grep artist | sed 's/artist: //'`
		ALBUM=`id3ed -i "$f" | grep album | sed 's/album: //'`
		YEAR=`id3ed -i "$f" | grep year | sed 's/year: //'`
		TRACK=`id3ed -i "$f" | grep tracknum | sed 's/tracknum: //'`
	
		lame --mp3input -b $bitrate "$f" /tmp/"$f"
		echo "    Finished converting $f" >>$FILE
		mp3info -t "$SONG" -a "$ARTIST" -l "$ALBUM" -y "$YEAR" -n "$TRACK" /tmp/"$f"

		rm "$f"
		mv /tmp/"$f" "$FOLDER"
		echo "    Restored from temp directory" >>$FILE
		echo "Finished conversion" >>$FILE
	else
		echo "No mp3 files in current directory"
	fi
done
