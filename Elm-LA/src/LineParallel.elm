module LineParallel exposing (..)

import Lib.Utils exposing (..)
import Lib.Plane exposing (basic2D)

main = basic2D
    { pixPerSide = 500
    , unitsPerSide = 40
    , strokeWidth = 1.5
    , tickLength = 3
    , origin = { x = 20, y = 20 }
    }
    [ Line { xCof = 2, yCof = -3, rhs = -5 } Red
    , Line { xCof = -4, yCof = 6, rhs = -14 } Blue
    ]
