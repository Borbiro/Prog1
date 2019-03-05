#include <stdio.h>
#include <omp.h>

int main(){
	#pragma omp parallel 
	while(1)
		{}
	return 0;
}