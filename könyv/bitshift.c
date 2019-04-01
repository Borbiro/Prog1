#include "stdio.h"

int main()
{
	int a = 5;
	int c = 0;
	while(a!=0){
		a = a << 1;
		c = c + 1;
	}
	printf("%d\n", c);
}