PARTITION=$1
NBGPUS=$2
NBWEEK=$3

export MODELPARAMS="'{\"model\": \"mistralai/Mistral-Small-24B-Instruct-2501\", \"tokenizer_mode\": \"mistral\", \"config_format\": \"mistral\", \"load_format\": \"mistral\", \"guided_decoding_backend\": \"xgrammar\", \"seed\": 1, \"tensor_parallel_size\": ${NBGPUS}}'"
export SAMPLINGPARAMS="'{\"temperature\": 0.15, \"seed\": 1, \"max_tokens\": 256}'"
export NAME=Mistral-Small-24B-Instruct-2501-seed1

export TWEETSFILE=/lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject/text4annotate/week_${NBWEEK}_twitter_candidates_mentions_4annotation.csv
export TWEETSCOLUMN=cleaned_text
export SYSTEMPROMT=/lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject/system_prompt_spanish.txt
export USERPROMT=/lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject/user_prompt_voteintention_multiple_all_spanish.txt

export BASEPATH=/lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject
export OUTFOLDER=${BASEPATH}/results/${NAME}/week_${NBWEEK}_twitter_candidates_mentions_4annotation

echo ${PARTITION}
echo ${NBGPUS}

sbatch \
    --job-name=${NAME} \
    --ntasks-per-node=${NBGPUS} \
    --gres=gpu:${PARTITION}:${NBGPUS} \
    --output=${OUTFOLDER}/%j.log  \
    --error=${OUTFOLDER}/%j.out  \
    /lustre/fswork/projects/rech/nmf/umu89ib/dev/chileProject/annotate_tweets_a100_jeanzay.slurm
