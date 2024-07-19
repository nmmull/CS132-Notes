module ExampleLine exposing (..)

import Utils exposing (..)
import Plane exposing (basic2D)

main = basic2D
    { pixPerSide = 500
    , unitsPerSide = 40
    , strokeWidth = 1.5
    , tickLength = 3
    , origin = { x = 20, y = 20 }
    }
    [ Line { xCof = 2, yCof = 3, rhs = -6 } Red
    , Point { x = 6, y = -6 } Red
    , Point { x = 12, y = -10 } Red
    , Point { x = -9, y = 4 } Red
    ]
