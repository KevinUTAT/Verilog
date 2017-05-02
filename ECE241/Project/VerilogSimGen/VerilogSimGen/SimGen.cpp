/*
* File:   SimGen.cpp
* Author: user
*
* Created on October 2, 2016, 11:30 AM
*/

#include <cstdlib>
#include "iostream"
#include "string"
#include <math.h>

using namespace std;


int main(void)
{
	string fileName, topLevel;

	int inputNum;

	int SW[8][256];


	for (int m = 0; m < 8; m++) {
		for (int n = 0; n < 256; n++) {
			int zero, cond, mplus;
			SW[m][n] = 1;
			mplus = m + 1;
			zero = n % (int)(pow(2, mplus));
			cond = pow(2, m);

			if (zero < cond) SW[m][n] = 0;
		}
	}


	//asking for info
	cout << "Please input your file_name top_level_module_name > ";
	cin >> fileName >> topLevel;
	cout << "Please indicate how many inputs you have > ";
	cin >> inputNum;



	//the fllowing is the heading of the sim script
	cout << "vlib work" << '\n';
	cout << '\n';
	cout << "vlog " << fileName << '\n';
	cout << '\n';
	cout << "vsim " << topLevel << '\n';
	cout << '\n';
	cout << "log {/*}" << '\n';
	cout << "add wave {/*}" << '\n';
	cout << '\n';

	//the fllowing is the test cases of the sim script
	for (int n = 0; n < pow(2, inputNum + 1); n++) {
		cout << "#test#" << n << '\n';
		for (int m = 0; m <= inputNum; m++) {
			cout << "force {SW[" << m << "]} " << SW[m][n] << '\n';
		}
		cout << "run 10ns" << '\n';
		cout << '\n';
	}



	cout << "Program finished, ENTER to exit" << endl;
	cin.get();

	
}