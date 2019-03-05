#include <iostream>

using namespace std;

int main(){
	int a=5;
	int b=7;

	//Valtozoval:
	//int c=a;
	//a=b;
	//b=c;

	//Plusz valtozo nelkul
	//a=a*b;
	//b=a/b;
	//a=a/b;

	//Exor
	a=a^b;
	b=a^b;
	a=a^b;
	cout<<"a="<<a<<" b="<<b<<endl;
	return 0;
}