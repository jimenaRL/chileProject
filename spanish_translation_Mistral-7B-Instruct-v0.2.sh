#!/bin/bash

PARTITION=$1
NBGPUS=$2
NBWEEK=$3

if [ $SERVER = "jeanzay" ]; then
    export BASEPATH=/lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject
elif [ $SERVER = "in2p3" ]; then
    export BASEPATH=/sps/humanum/user/jroyolet/dev/chileProject
fi

export SCRIPT=${BASEPATH}/slurm/${SERVER}/async_translations_${PARTITION}.slurm
export INPUTFILE="${BASEPATH}/text4annotate/week_${NBWEEK}_twitter_candidates_mentions_4annotation.csv"
export OUTPUTFOLDER="${BASEPATH}/translations_text/week_${NBWEEK}_twitter_candidates_mentions_4annotation"
export NAME="${NBGPUS}x${PARTITION}w${NBWEEK}"
export NBGPUS=$NBGPUS

export GRES="gpu:${PARTITION}:${NBGPUS}"
export OUTPUT="${OUTPUTFOLDER}/%j.log"
export ERROR="${OUTPUTFOLDER}/%j.out"

echo "SERVER: ${SERVER}"
echo "NAME: ${NAME}"
echo "SCRIPT: ${SCRIPT}"
echo "PARTITION: ${PARTITION}"
echo "NBGPUS: ${NBGPUS}"
echo "NBWEEK: ${NBWEEK}"
echo "INPUTFILE: ${INPUTFILE}"
echo "OUTPUTFOLDER: ${OUTPUTFOLDER}"
echo "GRES: ${GRES}"
echo "OUTPUT: ${OUTPUT}"
echo "ERROR: ${ERROR}"

sbatch \
    --job-name=${NAME} \
    --ntasks-per-node=${NBGPUS} \
    --gres=${GRES} \
    --output=${OUTPUT}  \
    --error=${ERROR}  \
    ${SCRIPT}
