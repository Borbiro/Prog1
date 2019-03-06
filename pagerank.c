#include <stdio.h>
#include <math.h>

void
kiir (double tomb[], int db){
	
	int i;
	
	for (i=0; i<db; ++i){
		printf("%f\n",tomb[i]);
	}
}

double
tavolsag (double PR[], double PRv[], int n){
	
	int i;
	double osszeg=0;
	
	for (i = 0; i < n; ++i)
		osszeg += (PRv[i] - PR[i]) * (PRv[i] - PR[i]);
	
	return sqrt(osszeg);
}

void
pagerank(double T[4][4]){
	double PR[4] = { 0.0, 0.0, 0.0, 0.0 }; //ebbe megy az eredmény
	double PRv[4] = { 1.0/4.0, 1.0/4.0, 1.0/4.0, 1.0/4.0}; //ezzel szorzok
	
	int i, j;
	
	for(;;){
		
		// ide jön a mátrix művelet		
		
		for (i=0; i<4; i++){
			PR[i]=0.0;
			for (j=0; j<4; j++){
				PR[i] = PR[i] + T[i][j]*PRv[j];
			}
		}
	
			if (tavolsag(PR,PRv,4) < 0.0000000001) 
				break;
		
		// ide meg az átpakolás PR-ből PRv-be
			
			for (i=0;i<4; i++){
				PRv[i]=PR[i];
			}	
	}
	
	kiir (PR, 4);
}

int main (void){
	double L[4][4] = {
		{0.0,  0.0,      1.0/3.0,  0.0},
		{1.0,  1.0/2.0,  1.0/3.0,  1.0},
		{0.0,  1.0/2.0,  0.0,      0.0},
		{0.0,  0.0, 	 1.0/3.0,  0.0}
	};	
	
	double L1[4][4] = {
		{0.0,  0.0,      1.0/3.0,  0.0},
		{1.0,  1.0/2.0,  1.0/3.0,  0.0},
		{0.0,  1.0/2.0,  0.0,      0.0},
		{0.0,  0.0, 	 1.0/3.0,  0.0}
	};
	
	double L2[4][4] = {
		{0.0,  0.0,      1.0/3.0,  0.0},
		{1.0,  1.0/2.0,  1.0/3.0,  0.0},
		{0.0,  1.0/2.0,  0.0,      0.0},
		{0.0,  0.0, 	 1.0/3.0,  1.0}
	};
	
	printf("\nAz eredeti mátrix értékeivel történő futás:\n");
	pagerank(L);
	
	printf("\nAmikor az egyik oldal semmire sem mutat:\n");
	pagerank(L1);
	
	printf("\nAmikor az egyik oldal csak magára mutat:\n");
	pagerank(L2);
	
	printf("\n");

	return 0;
}
