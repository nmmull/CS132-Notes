module StepExample4 exposing (..)

import Lib.AsciiStepper exposing (basicASCII)

scene = """⎡3  -9  12  -9   6     15 ⎤
⎢                         ⎥
⎢0  3   -6  6    4     -5 ⎥
⎢                         ⎥
⎣0  0   0   0   -2/3  -8/3⎦
=====
⎡1  -3  4   -3   2     5  ⎤
⎢                         ⎥
⎢0  3   -6  6    4     -5 ⎥
⎢                         ⎥
⎣0  0   0   0   -2/3  -8/3⎦

normalize leading entry A[0,0]
=====
⎡1  -3  4   -3   2     5  ⎤
⎢                         ⎥
⎢0  1   -2  2   4/3   -5/3⎥
⎢                         ⎥
⎣0  0   0   0   -2/3  -8/3⎦

normalize leading entry A[1,1]
=====
⎡1  0  -2  3   6     0  ⎤
⎢                       ⎥
⎢0  1  -2  2  4/3   -5/3⎥
⎢                       ⎥
⎣0  0  0   0  -2/3  -8/3⎦

zero out A[0,1]
=====
⎡1  0  -2  3   6    0  ⎤
⎢                      ⎥
⎢0  1  -2  2  4/3  -5/3⎥
⎢                      ⎥
⎣0  0  0   0   1    4  ⎦

normalize leading entry A[2,4]
=====
⎡1  0  -2  3   0   -24 ⎤
⎢                      ⎥
⎢0  1  -2  2  4/3  -5/3⎥
⎢                      ⎥
⎣0  0  0   0   1    4  ⎦

zero out A[0,4]
=====
⎡1  0  -2  3  0  -24⎤
⎢                   ⎥
⎢0  1  -2  2  0  -7 ⎥
⎢                   ⎥
⎣0  0  0   0  1   4 ⎦

zero out A[1,4]"""

main = basicASCII "=====" scene
