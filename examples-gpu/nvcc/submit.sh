#!/bin/bash
#SBATCH -c 1
#SBATCH --gres=gpu:1
#SBATCH --partition=agpuq
#SBATCH --mem=1G
#SBATCH -t 00:01:00

module load cuda

./transpose
