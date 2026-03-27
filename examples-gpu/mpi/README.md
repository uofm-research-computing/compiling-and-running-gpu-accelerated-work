# MPI example
A multipart example using MPI and OpenMP/OpenACC with Fortran. The repo used in this example has great examples.

## Compilation
To compile on a login node:
```
module load nvhpc-hpcx-cuda12
git clone https://github.com/ENCCS/gpu-programming.git
cd gpu-programming/content/examples/mpi_acc/
make all-examples OMP="-fopenmp -O3 -mp=gpu -gpu=cc70,cc80,managed,cuda12.3"
cp laplace_mpiacc ../../../../ 
```

The "cc70" and "cc80" are for targetting Volta and Ampere GPUs, specifically the V100 and A100 found on bigblue.
"cuda12.3" says to use the cuda 12.3 driver that we have on the cluster.

These might change. For example, on itiger, you would need to target "cuda12.6" driver, "cc90" for h100, and "cc89" for rtx5000/6000 GPUs.

The "managed" option just tells the compiler to manage memory between host and device (i.e. transfer data back and forth). This could be "unified" on itiger H100 GPU.

## Job Submission
Just run the following on the login node:
```
sbatch submit.sh
```

## Citations and other reading material
[ENCCS gpu programming tutorial](https://github.com/ENCCS/gpu-programming/tree/main)
[Nvidia HPC compilers reference guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/)
[OpenMP reference guides](https://www.openmp.org/resources/refguides/)
[OpenMP presentations, Videos, and more](https://www.openmp.org/resources/openmp-presentations/)
