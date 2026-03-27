#include <omp.h>
#include <iostream>
#include <vector>
#include <random>

#define INDX( row, col, ld ) ( ( (col) * (ld) ) + (row) )

int main()
{
	std::cout << "Found " << omp_get_num_devices() << " devices\n";
	
	//initialize a random number generator
	std::mt19937 randGen(1234);
	std::uniform_real_distribution<float> randDist(-10,10);
	
	//create random 10x10 matrix
	std::vector<float> randMat;
	uint nRow, nCol;
	nRow=nCol=10;
	
	for(int i=0;i<nCol;i++)
		for(int j=0;j<nRow;j++)
			randMat.emplace_back(randDist(randGen));
	
	//setup an output matrix
	std::vector<float> transMat(randMat.size(),0.0);
	
	// Perform the transpose inline
	//"#pragma omp parallel for" is the normal CPU way to perform this
	
	//openmp handles pointers
	float *output=transMat.data();
	float *input=randMat.data();
	
	//This reads as memory map to/from device "output" memory for 0 to nRow*nCol 
	//and memory map to "input" memory for 0 to nRow*nCol 
	#pragma omp target map(tofrom:output[0:nRow*nCol]) map(to:input[0:nRow*nCol])
	{
	#pragma omp teams distribute parallel for
	for(int i=0;i<nRow;i++)
		for(int j=0;j<nCol;j++)
			transMat[INDX(i,j,nRow)]=randMat[INDX(j,i,nRow)];	
	}
	//Since we are out of that region, this should be synchronized
	
	std::cout << "Original Matrix: \n";
	for(int i=0;i<nCol;i++)
	{
		for(int j=0;j<nRow;j++)
			std::cout << randMat[INDX(j,i,nRow)] << ' ';
		std::cout << '\n';
	}
	
	std::cout << "Transposed Matrix: \n";
	for(int i=0;i<nCol;i++)
	{
		for(int j=0;j<nRow;j++)
			std::cout << transMat[INDX(j,i,nRow)] << ' ';
		std::cout << '\n';
	}
	

	return 0;

}
