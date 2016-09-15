#!/bin/bash

# Initialisation ###############################################################

# Some useful functions
function silent() {
	"$@" > /dev/null 2>&1
}

function echoerr() {
	echo "$@" 1>&2
}

function valid() {
	if [ $? -ne 0 ]
	then
		echoerr "==== Error at :" "$1" "===="
		exit
	fi
}


# Parameters and variables
start_time=$SECONDS
ft="jpeg"

images_per_second="24"
thumb_size="128"
keep_pictures="false"

while [ "$1" != "" ]
do
	case "$1" in
		"-r")
			images_per_second="$2"
			shift
			;;
		"-t")
			thumb_size="$2"
			shift
			;;
		"-all")
			keep_pictures="true"
			;;
		*)
			if [ "$src" = "" ]
			then
				src="$1"
			else
				dest="$1"
			fi
	esac
	shift
done

if [ "$src" = "" ] || [ "$dest" = "" ]
then
	echoerr "==== Error ===="
	echoerr "Need at least a source video and a destination file"
	exit
fi


echo -e "\n========== Parameters =========="
echo "Images per second = $images_per_second"
echo "Thumbnails size = $thumb_size"
echo "Keep intermediate pictures = $keep_pictures"
echo "Source video = $src"
echo "Destination video = $dest"
echo -e "================================\n"


# Temporary directories
DIR=$(cd "$(dirname "$0")" && pwd)
audio="$DIR/audio_track.mp3"
pictures="$DIR/tmp_pict"
thumbnails="$DIR/tmp_thumbnails"
ascii="$DIR/tmp_ascii"
rm -rf "$pictures" "$thumbnails" "$ascii" "$audio"
mkdir "$pictures" "$thumbnails" "$ascii"


# Save the audio track #########################################################
silent ffmpeg -i "$src" -vn "$audio"
valid "Save the audio track" && echo "Audio track saved."


# Convert video into a list of images ##########################################
silent ffmpeg -i "$src" -r $images_per_second "$pictures"/%06d.$ft
valid "Convert video into a list of images"
nb_of_picts=`ls -1 "$pictures" | wc -l`
echo "$nb_of_picts images extracted."


# Generate thumbnails for theses images ########################################
for elt in "$pictures"/*
do
	pict_nb=`basename $elt .$ft`
	convert -thumbnail $thumb_size $elt "$thumbnails"/$pict_nb.$ft
	echo -en "Thumbnail : $pict_nb / $nb_of_picts \r"
done
echo "All thumbnails created."


# Convert each thumbnail into an ASCII-image ###################################
python3 python_src/main.py "$thumbnails" "$ascii"
valid "Convert each thumbnail into an ASCII-image"


# Generate the final video #####################################################
silent ffmpeg -framerate "$images_per_second" \
-i "$ascii"/%06d.$ft -i "$audio" "$dest"
valid "Generate the final video" && echo -e "\n Video '$dest' created."


if [ $keep_pictures = "false" ]
then
	rm -rf "$pictures" "$thumbnails" "$ascii" "$audio"
fi

echo "Total duration : $(($SECONDS - $start_time)) seconds."
