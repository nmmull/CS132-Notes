module StepExample3 exposing (..)

import Lib.AsciiStepper exposing (basicASCII)

scene = """⎡0  3   -6  6   4  -5⎤
⎢                    ⎥
⎢3  -9  12  -9  6  15⎥
⎢                    ⎥
⎣3  -7  8   -5  8  9 ⎦
=====
⎡3  -9  12  -9  6  15⎤
⎢                    ⎥
⎢0  3   -6  6   4  -5⎥
⎢                    ⎥
⎣3  -7  8   -5  8  9 ⎦

swap row 0 and row 1
=====
⎡3  -9  12  -9  6  15⎤
⎢                    ⎥
⎢0  3   -6  6   4  -5⎥
⎢                    ⎥
⎣0  2   -4  4   2  -6⎦

zero out A[2,0]
=====
⎡3  -9  12  -9   6     15 ⎤
⎢                         ⎥
⎢0  3   -6  6    4     -5 ⎥
⎢                         ⎥
⎣0  0   0   0   -2/3  -8/3⎦

zero out A[2,1]"""

main = basicASCII "=====" scene
