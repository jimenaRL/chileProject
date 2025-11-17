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
export NAME="${NBGPUS}x${PARTITION}sptrans"

echo "SERVER: ${SERVER}"
echo "NAME: ${NAME}"
echo "SCRIPT: ${SCRIPT}"
echo "PARTITION: ${PARTITION}"
echo "NBGPUS: ${NBGPUS}"
echo "NBWEEK: ${NBWEEK}"
echo "INPUTFILE: ${INPUTFILE}"
echo "OUTPUTFOLDER: ${OUTPUTFOLDER}"

sbatch \
    --job-name=${NAME} \
    --ntasks-per-node=${NBGPUS} \
    --gres=gpu:${PARTITION}:${NBGPUS} \
    --output=${OUTFOLDER}/%j.log  \
    --error=${OUTFOLDER}/%j.out  \
    ${SCRIPT}
