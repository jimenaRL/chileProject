#!/bin/bash

PARTITION=$1
NBGPUS=$2
NBWEEK=$3
LANGUAGE=$4

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
export USERPROMT=${BASEPATH}/prompts/user_prompt_voteintention_multiple_all_${LANGUAGE}.txt
export CHOICES=${BASEPATH}/choices/multiple.txt

export OUTFOLDER=${BASEPATH}/annotations/${NAME}/guided/voteintention/multiple/week_${NBWEEK}_twitter_candidates_mentions_4annotation/${LANGUAGE}

echo "SERVER: ${SERVER}"
echo "SCRIPT: ${SCRIPT}"
echo "PARTITION: ${PARTITION}"
echo "NBGPUS: ${NBGPUS}"
echo "NBWEEK: ${NBWEEK}"

sbatch \
    --job-name=aw${NBWEEK}${LANGUAGE}${PARTITION} \
    --ntasks-per-node=${NBGPUS} \
    --gpus=${NBGPUS} \
    --output=${OUTFOLDER}/%j.log  \
    --error=${OUTFOLDER}/%j.out  \
    ${SCRIPT}
