#pragma GCC diagnostic ignored "-Wunused-result"

#include <cstdio>
#include <algorithm>
#include <cassert>
#include <map>

double e[1 << 24]; // up to 23 bits.
// 0 (23 bits: 1 white 0 black)
// 10 (22 bits: 1 white 0 black)
// 110 (21 bits...
// e[?] -> expected number of taken white balls

const char * toBinStr(int code) {
	static char str[24 + 1] = {};
	for (int i = 0; i < 24; i++) {
		str[23 - i] = (char)('0' + ((code >> i) & 1));
	}
	return str;
}

struct Pair {

	int code; // 1 white 0 black

	int nBalls;

};

bool operator < (const Pair &left, const Pair &right) {
	if (left.code != right.code) {
		return left.code < right.code;
	} else {
		return left.nBalls < right.nBalls;
	}
}

std::map<Pair, double> ee; // {nBalls, code} -> expected number of taken white balls

double getE(const Pair &pair, int remOps) {
	if (remOps == 0) {
		return 0;
	}
	int nBalls = pair.nBalls;
	int code = pair.code;
	if (nBalls == 23) {
		return e[code];
	}
	assert(nBalls > 23);
	if (ee.count(pair) == 0) {
		double sum = 0;
		for (int chosenA = 0; chosenA < nBalls / 2; chosenA++) {
			int ballA = ((code >> chosenA) & 1);
			int codeA = (code & ((1 << chosenA) - 1)) + ((code >> 1) & ~((1 << chosenA) - 1));
			int chosenB = nBalls - 1 - chosenA;
			int ballB = ((code >> chosenB) & 1);
			int codeB = (code & ((1 << chosenB) - 1)) + ((code >> 1) & ~((1 << chosenB) - 1));
			sum += std::max(
				ballA + getE(Pair{codeA, nBalls - 1}, remOps - 1),
				ballB + getE(Pair{codeB, nBalls - 1}, remOps - 1));
		}
		sum *= 2;
		if (nBalls % 2 == 1) {
			int chosenA = nBalls / 2;
			int ballA = ((code >> chosenA) & 1);
			int codeA = (code & ((1 << chosenA) - 1)) + ((code >> 1) & ~((1 << chosenA) - 1));
			sum += ballA + getE(Pair{codeA, nBalls - 1}, remOps - 1);
		}
		ee[pair] = sum / nBalls;
	}
	return ee[pair];
}

int main() {
	int nBalls, nOps;
	scanf("%d %d", &nBalls, &nOps);
	for (int b = nBalls - nOps + 1; b <= 23; b++) {
		for (int code = (1 << 24) - (1 << (b + 1)); code < (1 << 24) - (1 << b); code++) {
			// printf("b=%d code=%s\n", b, toBinStr(code));
			double sum = 0;
			for (int chosenA = 0; chosenA < b / 2; chosenA++) {
				int ballA = ((code >> chosenA) & 1);
				int codeA = (code & ((1 << chosenA) - 1)) + (((code >> 1) + (1 << 23)) & ~((1 << chosenA) - 1));
				// printf("chosenA=%d ballA=%d codeA=%s\n", chosenA, ballA / MUL, toBinStr(codeA));
				int chosenB = b - 1 - chosenA;
				int ballB = ((code >> chosenB) & 1);
				int codeB = (code & ((1 << chosenB) - 1)) + (((code >> 1) + (1 << 23)) & ~((1 << chosenB) - 1));
				// printf("chosenB=%d ballB=%d codeB=%s\n", chosenB, ballB / MUL, toBinStr(codeB));
				sum += std::max(ballA + e[codeA], ballB + e[codeB]);
			}
			sum *= 2;
			if (b % 2 == 1) {
				int chosen = b / 2;
				int ballA = ((code >> chosen) & 1);
				int codeA = (code & ((1 << chosen) - 1)) + (((code >> 1) + (1 << 23)) & ~((1 << chosen) - 1));
				// printf("chosen+=%d ballA=%d codeB=%s\n", chosen, ballA / MUL, toBinStr(codeA));
				sum += ballA + e[codeA];
			}
			e[code] = sum / b;
		}
	}
	int code = 0;
	for (int i = 0; i < nBalls; i++) {
		char c;
		scanf(" %c", &c);
		if (c == 'W') {
			code |= 1 << i;
		}
	}
	if (nBalls <= 23) {
		code += (1 << 24) - (1 << (nBalls + 1));
		printf("%.7f", e[code]);
	} else {
		printf("%.7f", getE(Pair{code, nBalls}, nOps));
	}
	return 0;
}
