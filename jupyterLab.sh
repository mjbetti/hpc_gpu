#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --account=accre_guests_acc
#SBATCH --partition=pascal
#SBATCH --gres=gpu:2
#SBATCH --time=5-00:00:00
#SBATCH --mem=48GB
#SBATCH --output=/home/bettimj/gamazon_rotation/deep_learning_tcga_lc/jupyter.log

source activate /home/bettimj/miniconda3/envs/torch-gpu

cat /etc/hosts
jupyter lab --ip=0.0.0.0 --port=8889
