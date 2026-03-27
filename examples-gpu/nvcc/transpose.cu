#include <iostream>
#include <vector>
#include <random>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
//#include <cuda/cmath>
#include <cuda.h>

//Newer versions of ceil_div mentioned in documentation
__host__ __device__ constexpr size_t ceil_div(size_t a, size_t b) {
    return (a + b - 1) / b;
}


/* definitions of thread block size in X and Y directions */

#define THREADS_PER_BLOCK_X 16
#define THREADS_PER_BLOCK_Y 16

/* macro to index a 1D memory array with 2D indices in column-major order */
/* ld is the leading dimension, i.e. the number of rows in the matrix     */

#define INDX( row, col, ld ) ( ( (col) * (ld) ) + (row) )

/* CUDA kernel for shared memory matrix transpose */

__global__ void smem_cuda_transpose(int m,
                                    float *a,
                                    float *c )
{

    /* declare a statically allocated shared memory array */

    __shared__ float smemArray[THREADS_PER_BLOCK_X][THREADS_PER_BLOCK_Y];

    /* determine my row and column indices for the error checking code */

    const int myRow = blockDim.x * blockIdx.x + threadIdx.x;
    const int myCol = blockDim.y * blockIdx.y + threadIdx.y;

    /* determine my row tile and column tile index */

    const int tileX = blockDim.x * blockIdx.x;
    const int tileY = blockDim.y * blockIdx.y;

    if( myRow < m && myCol < m )
    {
        /* read from global memory into shared memory array */
        smemArray[threadIdx.x][threadIdx.y] = a[INDX( tileX + threadIdx.x, tileY + threadIdx.y, m )];
    } /* end if */

    /* synchronize the threads in the thread block */
    __syncthreads();

    if( myRow < m && myCol < m )
    {
        /* write the result from shared memory to global memory */
        c[INDX( tileY + threadIdx.x, tileX + threadIdx.y, m )] = smemArray[threadIdx.y][threadIdx.x];
    } /* end if */
    return;

} /* end smem_cuda_transpose */

int main()
{
	//initialize a random number generator
	std::mt19937 randGen(1234);
	std::uniform_real_distribution<float> randDist(-10,10);
	
	//create random 10x10 matrix
	std::vector<float> randMat_h;
	uint nRow=10, nCol=10;
	for(int i=0;i<nCol;i++)
		for(int j=0;j<nRow;j++)
			randMat_h.emplace_back(randDist(randGen));
	
	thrust::device_vector<float> randMat_d=randMat_h;//copy to device
	thrust::device_vector<float> transMat_d(randMat_h.size(),0);//allocate a device vector for output
	cudaDeviceSynchronize();
	
	uint3 threads{THREADS_PER_BLOCK_X,THREADS_PER_BLOCK_Y,1};
	//newer version of cuda library not on cluster
	//int blocks = cuda::ceil_div(randMat_d.size(), threads);//this will be 1=ceil(100/256)
	//version defined above
	uint3 blocks;
	blocks.x = ceil_div(nCol, threads.x);
	blocks.y = ceil_div(nRow, threads.y);
	blocks.z = 1;
	
	//A kernel call
	smem_cuda_transpose<<<blocks,threads>>>(nRow,
			thrust::raw_pointer_cast(randMat_d.data()),
			thrust::raw_pointer_cast(transMat_d.data()));
	cudaDeviceSynchronize();

	thrust::host_vector<float> transMat_h=transMat_d;
	cudaDeviceSynchronize();
	
	std::cout << "Original Matrix: \n";
	for(int i=0;i<nCol;i++)
	{
		for(int j=0;j<nRow;j++)
			std::cout << randMat_h[INDX(j,i,nRow)] << ' ';
		std::cout << '\n';
	}
	
	std::cout << "Transposed Matrix: \n";
	for(int i=0;i<nCol;i++)
	{
		for(int j=0;j<nRow;j++)
			std::cout << transMat_h[INDX(j,i,nRow)] << ' ';
		std::cout << '\n';
	}
	
	return 0;
}
