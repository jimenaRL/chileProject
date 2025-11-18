#!/bin/bash

PARTITION=$1
NBWEEK=$2

if [ $SERVER = "jeanzay" ]; then
    export BASEPATH=/lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject
elif [ $SERVER = "in2p3" ]; then
    export BASEPATH=/sps/humanum/user/jroyolet/dev/chileProject
fi

export SCRIPT=${BASEPATH}/slurm/${SERVER}/async_translations_${PARTITION}.slurm
export INPUTFILE=${BASEPATH}/text4annotate/week_${NBWEEK}_twitter_candidates_mentions_4annotation.csv
export OUTPUTFOLDER=${BASEPATH}/translations_text/week_${NBWEEK}_twitter_candidates_mentions_4annotation
export NAME=${PARTITION}tw${NBWEEK}

export OUTPUT=${OUTPUTFOLDER}/%j.log
export ERROR=${OUTPUTFOLDER}/%j.out

echo "SERVER: ${SERVER}"
echo "NAME: ${NAME}"
echo "SCRIPT: ${SCRIPT}"
echo "PARTITION: ${PARTITION}"
echo "NBWEEK: ${NBWEEK}"
echo "INPUTFILE: ${INPUTFILE}"
echo "OUTPUTFOLDER: ${OUTPUTFOLDER}"
echo "GRES: ${GRES}"
echo "OUTPUT: ${OUTPUT}"
echo "ERROR: ${ERROR}"

sbatch \
    --job-name=${NAME} \
    --output=${OUTPUT}  \
    --error=${ERROR}  \
    ${SCRIPT}
