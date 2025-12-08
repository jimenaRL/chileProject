#!/bin/bash

PARTITION=$1
NBGPUS=$2
NBWEEK=$3
LANGUAGE=$4
CANDIDATE=$5
TASK=$6

if [ $SERVER = "jeanzay" ]; then
    export BASEPATH=/lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject
elif [ $SERVER = "in2p3" ]; then
    export BASEPATH=/sps/humanum/user/jroyolet/dev/chileProject
fi

export SCRIPT=${BASEPATH}/slurm/${SERVER}/annotate_tweets_${PARTITION}.slurm

export MODELPARAMS="'{\"model\": \"mistralai/Mistral-Small-24B-Instruct-2501\", \"tokenizer_mode\": \"mistral\", \"config_format\": \"mistral\", \"load_format\": \"mistral\", \"guided_decoding_backend\": \"xgrammar\", \"seed\": 1, \"tensor_parallel_size\": ${NBGPUS}}'"
export SAMPLINGPARAMS="'{\"temperature\": 0.15, \"seed\": 33, \"max_tokens\": 256}'"
export NAME=Mistral-Small-24B-Instruct-2501-seed1

if [[ "$LANGUAGE" = "spanish" ]]
then
    export TWEETSCOLUMN=text
    export TWEETSFILE=${BASEPATH}/text4annotate/week_${NBWEEK}_twitter_candidates_mentions_4annotation.csv
elif [[ "$LANGUAGE" = "english" ]]
then
    export TWEETSCOLUMN=english
    export TWEETSFILE=${BASEPATH}/translations_text/week_${NBWEEK}_translations_text_column.csv
else
     echo "Bad LANGUAGE variable: ${LANGUAGE}"
     exit 1
fi
export SYSTEMPROMT=${BASEPATH}/prompts/system_prompt_${LANGUAGE}.txt
export USERPROMT=${BASEPATH}/prompts/user_prompt_${TASK}_binary_${CANDIDATE}_${LANGUAGE}.txt
export CHOICES=${BASEPATH}/choices/binary.txt

export OUTFOLDER=${BASEPATH}/annotations/${NAME}/guided/${TASK}/binary/${CANDIDATE}/week_${NBWEEK}_twitter_candidates_mentions_4annotation/${LANGUAGE}

echo "SERVER: ${SERVER}"
echo "SCRIPT: ${SCRIPT}"
echo "PARTITION: ${PARTITION}"
echo "NBGPUS: ${NBGPUS}"
echo "NBWEEK: ${NBWEEK}"
echo "CANDIDATE: ${CANDIDATE}"
echo "OUTFOLDER: ${OUTFOLDER}"

sbatch \
    --job-name=b${NBWEEK}${LANGUAGE:0:2}_${TASK:0:1}${CANDIDATE:0:1} \
    --ntasks-per-node=${NBGPUS} \
    --gpus=${NBGPUS} \
    --output=${OUTFOLDER}/%j.log  \
    --error=${OUTFOLDER}/%j.out  \
    ${SCRIPT}
