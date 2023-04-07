```cpp
void create()
{
    // file pointer
    fstream fout;
  
    // opens an existing csv file or creates a new file.
    fout.open("reportcard.csv", ios::out | ios::app);
  
    cout << "Enter the details of 5 students:"
         << " roll name maths phy chem bio";
    << endl;
  
    int i, roll, phy, chem, math, bio;
    string name;
  
    // Read the input
    for (i = 0; i < 5; i++) {
  
        cin >> roll
            >> name
            >> math
            >> phy
            >> chem
            >> bio;
  
        // Insert the data to file
        fout << roll << ", "
             << name << ", "
             << math << ", "
             << phy << ", "
             << chem << ", "
             << bio
             << "\n";
    }
}
```

```cpp
void read_record()
{
  
    // File pointer
    fstream fin;
  
    // Open an existing file
    fin.open("reportcard.csv", ios::in);
  
    // Get the roll number
    // of which the data is required
    int rollnum, roll2, count = 0;
    cout << "Enter the roll number "
         << "of the student to display details: ";
    cin >> rollnum;
  
    // Read the Data from the file
    // as String Vector
    vector<string> row;
    string line, word, temp;
  
    while (fin >> temp) {
  
        row.clear();
  
        // read an entire row and
        // store it in a string variable 'line'
        getline(fin, line);
  
        // used for breaking words
        stringstream s(line);
  
        // read every column data of a row and
        // store it in a string variable, 'word'
        while (getline(s, word, ', ')) {
  
            // add all the column data
            // of a row to a vector
            row.push_back(word);
        }
  
        // convert string to integer for comparision
        roll2 = stoi(row[0]);
  
        // Compare the roll number
        if (roll2 == rollnum) {
  
            // Print the found data
            count = 1;
            cout << "Details of Roll " << row[0] << " : \n";
            cout << "Name: " << row[1] << "\n";
            cout << "Maths: " << row[2] << "\n";
            cout << "Physics: " << row[3] << "\n";
            cout << "Chemistry: " << row[4] << "\n";
            cout << "Biology: " << row[5] << "\n";
            break;
        }
    }
    if (count == 0)
        cout << "Record not found\n";
}
```

```cpp
void update_recode()
{
  
    // File pointer
    fstream fin, fout;
  
    // Open an existing record
    fin.open("reportcard.csv", ios::in);
  
    // Create a new file to store updated data
    fout.open("reportcardnew.csv", ios::out);
  
    int rollnum, roll1, marks, count = 0, i;
    char sub;
    int index, new_marks;
    string line, word;
    vector<string> row;
  
    // Get the roll number from the user
    cout << "Enter the roll number "
         << "of the record to be updated: ";
    cin >> rollnum;
  
    // Get the data to be updated
    cout << "Enter the subject "
         << "to be updated(M/P/C/B): ";
    cin >> sub;
  
    // Determine the index of the subject
    // where Maths has index 2,
    // Physics has index 3, and so on
    if (sub == 'm' || sub == 'M')
        index = 2;
    else if (sub == 'p' || sub == 'P')
        index = 3;
    else if (sub == 'c' || sub == 'C')
        index = 4;
    else if (sub == 'b' || sub == 'B')
        index = 5;
    else {
        cout << "Wrong choice.Enter again\n";
        update_record();
    }
  
    // Get the new marks
    cout << "Enter new marks: ";
    cin >> new_marks;
  
    // Traverse the file
    while (!fin.eof()) {
  
        row.clear();
  
        getline(fin, line);
        stringstream s(line);
  
        while (getline(s, word, ', ')) {
            row.push_back(word);
        }
  
        roll1 = stoi(row[0]);
        int row_size = row.size();
  
        if (roll1 == rollnum) {
            count = 1;
            stringstream convert;
  
            // sending a number as a stream into output string
            convert << new_marks;
  
            // the str() converts number into string
            row[index] = convert.str();
  
            if (!fin.eof()) {
                for (i = 0; i < row_size - 1; i++) {
  
                    // write the updated data
                    // into a new file 'reportcardnew.csv'
                    // using fout
                    fout << row[i] << ", ";
                }
  
                fout << row[row_size - 1] << "\n";
            }
        }
        else {
            if (!fin.eof()) {
                for (i = 0; i < row_size - 1; i++) {
  
                    // writing other existing records
                    // into the new file using fout.
                    fout << row[i] << ", ";
                }
  
                // the last column data ends with a '\n'
                fout << row[row_size - 1] << "\n";
            }
        }
        if (fin.eof())
            break;
    }
    if (count == 0)
        cout << "Record not found\n";
  
    fin.close();
    fout.close();
  
    // removing the existing file
    remove("reportcard.csv");
  
    // renaming the updated file with the existing file name
    rename("reportcardnew.csv", "reportcard.csv");
}
```
```cpp
void delete_record()
{
  
    // Open FIle pointers
    fstream fin, fout;
  
    // Open the existing file
    fin.open("reportcard.csv", ios::in);
  
    // Create a new file to store the non-deleted data
    fout.open("reportcardnew.csv", ios::out);
  
    int rollnum, roll1, marks, count = 0, i;
    char sub;
    int index, new_marks;
    string line, word;
    vector<string> row;
  
    // Get the roll number
    // to decide the data to be deleted
    cout << "Enter the roll number "
         << "of the record to be deleted: ";
    cin >> rollnum;
  
    // Check if this record exists
    // If exists, leave it and
    // add all other data to the new file
    while (!fin.eof()) {
  
        row.clear();
        getline(fin, line);
        stringstream s(line);
  
        while (getline(s, word, ', ')) {
            row.push_back(word);
        }
  
        int row_size = row.size();
        roll1 = stoi(row[0]);
  
        // writing all records,
        // except the record to be deleted,
        // into the new file 'reportcardnew.csv'
        // using fout pointer
        if (roll1 != rollnum) {
            if (!fin.eof()) {
                for (i = 0; i < row_size - 1; i++) {
                    fout << row[i] << ", ";
                }
                fout << row[row_size - 1] << "\n";
            }
        }
        else {
            count = 1;
        }
        if (fin.eof())
            break;
    }
    if (count == 1)
        cout << "Record deleted\n";
    else
        cout << "Record not found\n";
  
    // Close the pointers
    fin.close();
    fout.close();
  
    // removing the existing file
    remove("reportcard.csv");
  
    // renaming the new file with the existing file name
    rename("reportcardnew.csv", "reportcard.csv");
}
```
```cpp
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {
    ifstream file;
    file.open("example.csv");
    string line;
    getline(file, line);
    while (getline(file, line)) {
        cout << line << endl;
    }
    file.close();
    return 0;
}
```