module StepperTest exposing (..)

import Lib.AsciiStepper exposing (basicASCII)

scene = """-x₀ - 2x₁ = 1

 x₀ +  x₁ = 2
=====
⎡-1  -2  1⎤
⎢         ⎥
⎣1   1   2⎦

make the augmented matrix
=====
⎡-1  -2  1⎤
⎢         ⎥
⎣0   -1  3⎦

R₀ ← R₀ + R₁
=====
⎡-1  -2  1 ⎤
⎢          ⎥
⎣0   1   -3⎦

R₁ ← (-1)R₁
=====
⎡-1  0  -5⎤
⎢         ⎥
⎣0   1  -3⎦

R₀ ← R₀ + 2R₁
=====
⎡1  0  5 ⎤
⎢        ⎥
⎣0  1  -3⎦

R₀ ← (-1)R₀
=====
x₀ = 5

x₁ = -3"""

main = basicASCII "=====" scene
