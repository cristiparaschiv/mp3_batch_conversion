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
fi

for f in *.mp3
do
	SONG=`id3ed -i "$f" | grep songname | sed 's/songname: //'`
	ARTIST=`id3ed -i "$f" | grep artist | sed 's/artist: //'`
	ALBUM=`id3ed -i "$f" | grep album | sed 's/album: //'`
	YEAR=`id3ed -i "$f" | grep year | sed 's/year: //'`
	TRACK=`id3ed -i "$f" | grep tracknum | sed 's/tracknum: //'`
	
	lame --mp3input -b $bitrate "$f" /tmp/"$f"

	mp3info -t "$SONG" -a "$ARTIST" -l "$ALBUM" -y "$YEAR" -n "$TRACK" /tmp/"$f"

	rm "$f"	
done

mv /tmp/*.mp3 "$FOLDER"

