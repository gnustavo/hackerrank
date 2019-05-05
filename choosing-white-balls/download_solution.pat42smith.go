package main
import ("bufio"; "fmt"; "io"; "os")

type Key struct {
	n, bits int32
}

var cache = make(map[Key]float64)

func score(N, K, bits int32) float64 {
	key := Key{ N, bits }
	if s, done := cache[key]; done {
		return s
	}
	total := 0.0
	for i := int32(0); 2 * i < N; i++ {
		add := 0.0
		for _, j := range [2]int32{ i, N - 1 - i } {
			a := 0.0
			if (bits >> uint(j)) & 1 != 0 {
				a = 1.0
			}
			if K > 1 {
				mask := (int32(1) << uint(j)) - 1
				b := bits & mask | (bits >> 1) &^ mask
				a += score(N - 1, K - 1, b)
			}
			if a > add {
				add = a
			}
		}
		if 2 * i + 1 == N {
			total += add
		} else {
			total += 2 * add
		}
	}
	s := total / float64(N)
	cache[key] = s
	return s
}

func main() {
	N := int32(ScanInt(1, 29))
	K := int32(ScanInt(1, int(N)))
	NewLine()
	s := ScanString(int(N), int(N))
	bits := int32(0)
	for n := int32(0); n < N; n++ {
		c := s[n]
		if c == 'W' {
			bits = 2 * bits + 1
		} else {
			Assert(c == 'B')
			bits = 2 * bits
		}
	}
	fmt.Printf("%.10f\n", score(N, K, bits))
}

// Boilerplate

func Assert(condition bool, items... interface{}) {
	if !condition {
		panic("assertion failed: " + fmt.Sprint(items...))
	}
}

func Log(items... interface{}) {
	fmt.Println(items...)
}

var Input = bufio.NewReader(os.Stdin)

func ReadByte() byte {
	b, e := Input.ReadByte()
	if e != nil {
		panic(e)
	}
	return b
}

func MaybeReadByte() (byte, bool) {
	b, e := Input.ReadByte()
	if e != nil {
		if e == io.EOF {
			return 0, false
		}
		panic(e)
	}
	return b, true
}

func UnreadByte() {
	e := Input.UnreadByte()
	if e != nil {
		panic(e)
	}
}

func NewLine() {
	for {
		b := ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			return
		default:
			panic(fmt.Sprintf("expecting newline, but found character <%c>", b))
		}
	}
}

func ScanInt(low, high int) int {
	return int(ScanInt64(int64(low), int64(high)))
}

func ScanUint(low, high uint) uint {
	return uint(ScanUint64(uint64(low), uint64(high)))
}

func ScanInt64(low, high int64) int64 {
	Assert(low <= high)
	for {
		b := ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			panic(fmt.Sprintf(
				"unexpected newline; expecting range %d..%d", low, high))
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			if high < 0 {
				panic(fmt.Sprintf(
					"found <%c> but expecting range %d..%d", b, low, high))
			}
			lw := low
			if lw < 0 {
				lw = 0
			}
			UnreadByte()
			x, e := _scanu64(uint64(lw), uint64(high))
			if e != "" {
				panic(fmt.Sprintf("%s %d..%d", e, low, high))
			}
			return int64(x)
		case '-':
			if low > 0 {
				panic(fmt.Sprintf(
					"found minus sign but expecting range %d..%d", low, high))
			}
			h := high
			if h > 0 {
				h = 0
			}
			x, e := _scanu64(uint64(-h), uint64(-low))
			if e != "" {
				panic(fmt.Sprintf( "-%s %d..%d", e, low, high))
			}
			return -int64(x)
		default:
			panic(fmt.Sprintf(
				"unexpected character <%c>; expecting range %d..%d", b, low, high))
		}
	}
}

func ScanUint64(low, high uint64) uint64 {
	Assert(low <= high)
	for {
		b := ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			panic(fmt.Sprintf(
				"unexpected newline; expecting range %d..%d", low, high))
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			UnreadByte()
			x, e := _scanu64(low, high)
			if e != "" {
				panic(fmt.Sprintf("%s %d..%d", e, low, high))
			}
			return x
		default:
			panic(fmt.Sprintf(
				"unexpected character <%c>; expecting range %d..%d", b, low, high))
		}
	}
}

func _scanu64(low, high uint64) (result uint64, err string) {
	x := uint64(0)
	buildnumber: for {
		b, ok := MaybeReadByte()
		if !ok {
			break buildnumber
		}
		switch b {
		case ' ', '\t', '\r':
			break buildnumber
		case '\n':
			UnreadByte()
			break buildnumber
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			d := uint64(b - '0')
			if (high - d) / 10 < x {
				return x, fmt.Sprintf("%d%c... not in range", x, b)
			}
			x = x * 10 + d
		default:
			return x, fmt.Sprintf("%d%c found; expecting range", x, b)
		}
	}
	if x < low || x > high {
		return x, fmt.Sprintf("%d not in range", x)
	}
	return x, ""
}

func ScanBytes(short, long int) []byte {
	Assert(1 <= short && short <= long)
	var b byte
	buf := make([]byte, long)
	skipws: for {
		b = ReadByte()
		switch b {
		case ' ', '\t', '\r':
			// keep looking
		case '\n':
			panic(fmt.Sprintf("unexpected newline; expecting string"))
		default:
			break skipws
		}
	}
	buf[0] = b
	length := 1
	buildstring: for {
		var ok bool
		b, ok = MaybeReadByte()
		if !ok {
			break buildstring
		}
		switch b {
		case ' ', '\t', '\r':
			break buildstring
		case '\n':
			UnreadByte()
			break buildstring
		default:
			if length >= long {
				panic(fmt.Sprintf("string length not in range %d..%d", short, long))
			}
			buf[length] = b
			length++
		}
	}
	if length < short {
		panic(fmt.Sprintf("string length not in range %d..%d", short, long))
	}
	return buf[:length]
}

func ScanString(short, long int) string {
	return string(ScanBytes(short, long))
}
