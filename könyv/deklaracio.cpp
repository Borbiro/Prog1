#include <iostream>

using namespace std;

int main()
{
	int a;
	int *b = &a;
	cout << "Adj meg egy számot: " << endl;
	cin >> a;
	cout << a << endl;
	return 0;
}