#include <bits/stdc++.h>

using namespace std;

vector<string> split_string(string);

double expected(int n, int k, const string &balls) 
{
    if (k == 0)
        return 0.0;

    static map<string, map<int, double> > memo;
    
    if (memo.count(balls) > 0) {
        map<int, double> &kmemo = memo[balls];
        if (kmemo.count(k) > 0) {
            return kmemo[k];
        }
    }

    int picks = 0;
    double prob = 0.0;
    
    for (int x = 0; x < n; ++x) {
        const char chars[3] = {balls[x], balls[n - x - 1], '\0'};
        
        if (strcmp(chars, "BB") != 0)
            picks += 1;
        
        if (k == 1)
            continue;           // optimization
        
        string lballs(balls);
        lballs.erase(x, 1);
        string rballs(balls);
        rballs.erase(n - x - 1, 1);
        
        if (strcmp(chars, "WB") == 0) {
            prob += expected(n-1, k-1, lballs);
        }
        else if (strcmp(chars, "BW") == 0) {
            prob += expected(n-1, k-1, rballs);
        }
        else {
            double lexpected = expected(n-1, k-1, lballs);
            double rexpected = expected(n-1, k-1, rballs);
            prob += lexpected > rexpected ? lexpected : rexpected;
        }
    }

    double result = (picks + prob) / n;

    memo[balls][k] = result;

    return result;
}


int main()
{
    string nk_temp;
    getline(cin, nk_temp);

    vector<string> nk = split_string(nk_temp);

    int n = stoi(nk[0]);

    int k = stoi(nk[1]);

    string balls;
    getline(cin, balls);

    // Write Your Code Here
    double value = expected(n, k, balls);
    
    cout << setprecision(20) << value << "\n";

    return 0;
}

vector<string> split_string(string input_string) {
    string::iterator new_end = unique(input_string.begin(), input_string.end(), [] (const char &x, const char &y) {
        return x == y and x == ' ';
    });

    input_string.erase(new_end, input_string.end());

    while (input_string[input_string.length() - 1] == ' ') {
        input_string.pop_back();
    }

    vector<string> splits;
    char delimiter = ' ';

    size_t i = 0;
    size_t pos = input_string.find(delimiter);

    while (pos != string::npos) {
        splits.push_back(input_string.substr(i, pos - i));

        i = pos + 1;
        pos = input_string.find(delimiter, i);
    }

    splits.push_back(input_string.substr(i, min(pos, input_string.length()) - i + 1));

    return splits;
}
