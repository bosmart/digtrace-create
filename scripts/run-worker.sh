#!/usr/bin/env bash

export MY_ID="$1"
export WORKERS="$2"
export INPUT_FOLDER="$3"
export OUTPUT_FOLDER="$4"

export HOME="/home/$(whoami)"
export PMVS_DIR="/usr/local/bin"
export MVG_DIR="/usr/local/bin"
export SCRIPTS_DIR="/source/openMVG/openMVG_Build/software/SfM"

COUNTER=0
for f in "$INPUT_FOLDER"/*;
do
    if (( $COUNTER % $WORKERS == $MY_ID ))
    then
        export OUT_INDIV="$OUTPUT_FOLDER/$(basename $f)"

        echo ========================================================
        echo Worker $MY_ID, input folder $f, output folder $OUT_INDIV

        [ -e $f/*.txt ] && rm $f/*.txt
        mkdir -p $OUTPUT_FOLDER/$(basename $f)/outputs

	echo ========================================================
	echo python $SCRIPTS_DIR/SfM_GlobalPipeline.py $f $OUT_INDIV/output
        python $SCRIPTS_DIR/SfM_GlobalPipeline.py $f $OUT_INDIV/outputs

        echo ========================================================
        echo $MVG_DIR/openMVG_main_openMVG2PMVS -i $OUT_INDIV/outputs/reconstruction_global/sfm_data.bin -o $OUT_INDIV/outputs/reconstruction_global
        $MVG_DIR/openMVG_main_openMVG2PMVS -i $OUT_INDIV/outputs/reconstruction_global/sfm_data.bin -o $OUT_INDIV/outputs/reconstruction_global

        echo ========================================================
        echo $PMVS_DIR/cmvs $OUT_INDIV/outputs/reconstruction_global/PMVS/ 50 12
        $PMVS_DIR/cmvs $OUT_INDIV/outputs/reconstruction_global/PMVS/ 50 12

        echo ========================================================
        echo $PMVS_DIR/genOption $OUT_INDIV/outputs/reconstruction_global/PMVS/
        $PMVS_DIR/genOption $OUT_INDIV/outputs/reconstruction_global/PMVS/

        echo ========================================================
        echo $PMVS_DIR/pmvs2 $OUT_INDIV/outputs/reconstruction_global/PMVS/ option-0000
        $PMVS_DIR/pmvs2 $OUT_INDIV/outputs/reconstruction_global/PMVS/ option-0000

	echo ========================================================
	echo python ply2bin.py $OUT_INDIV/outputs/reconstruction_global
	python ply2bin.py $OUT_INDIV/outputs/reconstruction_global

	mv $f/* $OUT_INDIV/
	rm -rf $f
    fi

    COUNTER=$((COUNTER+1))
done

