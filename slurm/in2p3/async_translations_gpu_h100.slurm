#!/bin/sh

# SLURM options:

#SBATCH --gres=gpu:h100:1
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=1
#SBATCH --ntasks=1                    # Exécuter une seule tâche

#SBATCH --mem=128G                    # Mémoire en MB par défaut
#SBATCH --time=6-23:59             #  Max temps execution en format « jours-heures:minutes »

#SBATCH --mail-user=jimena.royoletelier@sciencespo.fr # Où envoyer l'e-mail
#SBATCH --mail-type=ALL          # Événements déclencheurs (NONE, BEGIN, END, FAIL, ALL)

module load Programming_Languages/python/3.11.4
source /sps/humanum/user/jroyolet/environments/vllm-0.10.1/bin/activate


# Show shell used
echo "SHELL:"
echo $0

# show python used
echo "PYTHON:"
echo $(python --version)
echo $(which python)

# show gpus availables
nvidia-smi

export SCRIPT=/sps/humanum/user/jroyolet/dev/chileProject/async_translations.py

echo ""
echo "SCRIPT:"
echo "${SCRIPT}"

echo ""
echo "INPUTFILE:"
echo "${INPUTFILE}"

echo ""
echo "OUTPUTFOLDER:"
echo "${OUTPUTFOLDER}"

cmd="python ${SCRIPT} \
       --nbgpus=1 \
       --input_file=${INPUTFILE} \
       --results_folder=${OUTPUTFOLDER}"

echo ""
echo "[RUNNING] ${cmd}"

eval "$cmd"
