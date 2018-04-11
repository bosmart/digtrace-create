#!/usr/bin/env bash
export INPUT_FOLDER=/mnt/inputs
export OUTPUT_FOLDER=/mnt/outputs
export WORKERS=3

echo Downloading sensor database
wget https://www.dropbox.com/s/2qvwz1a8efkeh6m/sensor_width_camera_database.txt
mv ./sensor_width_camera_database.txt /source/openMVG/src/software/SfM/../../openMVG/exif/sensor_width_database/sensor_width_camera_database.txt

if (( $WORKERS == 2))
then

tmux new -d -s my-session 'bash run-worker.sh 0 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
        splitw -h -d 'bash run-worker.sh 1 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
	attach \;


elif (( $WORKERS == 3 ))
then

tmux new -d -s my-session 'bash run-worker.sh 0 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
        splitw -h -d 'bash run-worker.sh 1 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
        splitw -v -d 'bash run-worker.sh 2 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
	attach \;


elif (( $WORKERS == 4))
then

tmux new -d -s my-session 'bash run-worker.sh 0 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
	splitw -h -d 'bash run-worker.sh 1 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
	splitw -v -d 'bash run-worker.sh 2 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
	selectp -t 2 \; \
	splitw -v -d 'bash run-worker.sh 3 $WORKERS $INPUT_FOLDER $OUTPUT_FOLDER' \; \
	selectp -t 0 \; \
	attach \;

fi
