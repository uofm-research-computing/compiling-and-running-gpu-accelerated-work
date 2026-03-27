# CMAKE example
Example taken from the [CUDA SDK samples](https://github.com/NVIDIA/cuda-samples).

## Compilation
Run this on a login node:
```
module load cuda
git clone https://github.com/NVIDIA/cuda-samples.git
cd cuda-samples
git checkout v13.1
patch Samples/5_Domain_Specific/nbody/CMakeLists.txt < ../nbodyPatch
cd Samples/5_Domain_Specific/nbody/
mkdir build
cd build/
cmake .. -DCMAKE_CUDA_ARCHITECTURES="70;80"
cmake --build .
cp nbody ../../../../../
cd ../../../../../
```

The "CMAKE_CUDA_ARCHITECTURES" variable is used set the compilation target. On Bigblue, we will use 70 and 80 for Volta (V100) and Ampere (A100) architectures.

The patch is used to correct behavior. Alternatively, you can edit the CMakeLists.txt file to just use the correct architectures.

## Submission
Run this on a login node to submit the example:
```
sbatch submit.sh
```

## Citations and other reading material
[CMAKE_CUDA_ARCHITECTURES](https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_ARCHITECTURES.html)
[CUDA SDK samples](https://github.com/NVIDIA/cuda-samples).
