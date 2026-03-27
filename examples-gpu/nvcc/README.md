# Transpose example
Example taken from the [CUDA programming guide](https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/writing-cuda-kernels.html#matrix-transpose-example-using-shared-memory).

## Compilation
Run this on a login node:
```
module load cuda
nvcc transpose.cu -o transpose -arch=compute_70 --gpu-code sm_70,sm_80
```

## Submission
Run this on a login node to submit the example:
```
sbatch submit.sh
```

## Citations and other reading material
[PTX information](https://docs.nvidia.com/cuda/cuda-programming-guide/02-basics/nvcc.html#nvcc-ptx-and-cubin-generation)

[Thrust](https://nvidia.github.io/cccl/unstable/thrust/index.html)
