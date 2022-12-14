#pragma once

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

//parses csv file and returns contents by line.
vector<vector<string>> parseFile(string fname, bool printContents = false) {
	vector<vector<string>> content;
	vector<string> row;
	string line, word;
	fstream file(fname, ios::in);

	if (file.is_open())
	{
		while (getline(file, line))
		{
			row.clear();

			stringstream str(line);

			while (getline(str, word, ','))
				row.push_back(word);
			content.push_back(row);
		}
	}
	else
		cout << "Could not open the file\n";

	for (int i = 0; i < content.size(); i++)
	{
		for (int j = 0; j < content[i].size(); j++)
		{
			cout << content[i][j] << " ";
		}
		cout << "\n";
	}
	return content;
}
