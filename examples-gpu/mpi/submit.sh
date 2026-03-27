#!/bin/bash
#SBATCH -n 2
#SBATCH --gres=gpu:2
#SBATCH --partition=igpuq,agpuq
#SBATCH --mem=4G
#SBATCH -t 00:01:00

module load nvhpc-hpcx-cuda12

mpirun ./laplace_mpiacc
