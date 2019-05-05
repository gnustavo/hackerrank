#include <bits/stdc++.h>

using namespace std;

// Complete the angryChildren function below.
long angryChildren(int k, vector<int> packets) {
    sort(packets.begin(), packets.end());

    long cdiff = 0;
    
    for (int i=0; i<k; ++i) {
        int y = packets[i];
        for (vector<int>::iterator it=packets.begin(); it != packets.begin()+i; ++it) {
            if (*it < y)
                cdiff += y - *it;
            else
                cdiff += *it - y;
        }
    }

    long min_cdiff = cdiff;

    for (int i=k; i<packets.size(); ++i) {
        int x = packets[i-k];
        int y = packets[i];
        int min = x<y ? x : y;
        int max = x>y ? x : y;
        for (vector<int>::iterator it=packets.begin()+i-k+1; it != packets.begin()+i; ++it) {
            if (*it < min)
                cdiff += y - x;
            else if (*it > max)
                cdiff += x - y;
            else if (x < y)
                cdiff += x + y - 2*(*it);
            else
                cdiff += 2*(*it) - x - y;
        }
        if (cdiff < min_cdiff)
            min_cdiff = cdiff;
    }

    return min_cdiff;
}

int main()
{
    ofstream fout(getenv("OUTPUT_PATH"));

    int n;
    cin >> n;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    int k;
    cin >> k;
    cin.ignore(numeric_limits<streamsize>::max(), '\n');

    vector<int> packets(n);

    for (int i = 0; i < n; i++) {
        int packets_item;
        cin >> packets_item;
        cin.ignore(numeric_limits<streamsize>::max(), '\n');

        packets[i] = packets_item;
    }

    long result = angryChildren(k, packets);

    fout << result << "\n";

    fout.close();

    return 0;
}
