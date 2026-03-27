# OpenMP example
An example of using the newer OpenMP target offloading. The benefits to using openmp/openacc are:
 1. Can compile these with any OpenMP compliant compiler. Including llvm, gcc, and intel compilers.
 2. Completely inlines your code. No need to define a kernel.
 3. Don't need a GPU to do testing on smaller inputs.

## Compilation
To compile on a login node:
```
module load nvhpc
nvc++ testMP.cpp -fopenmp -O3 -mp=gpu -gpu=cc70,cc80,managed,cuda12.3 -o testMP
```

To see the ptx information, run:
```
nvc++ testMP.cpp -fopenmp -O3 -mp=gpu -gpu=cc70,cc80,managed,cuda12.3,keep -o testMP
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

## nvc and nvfortran
These compilers take many of the same options.

## Citations and other reading material
[Nvidia HPC compilers reference guide](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-ref-guide/)
[A great openmp tutorial](https://github.com/UoB-HPC/openmp-tutorial/tree/master)
[OpenMP reference guides](https://www.openmp.org/resources/refguides/)
[OpenMP presentations, Videos, and more](https://www.openmp.org/resources/openmp-presentations/)
