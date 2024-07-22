module LineIntersection exposing (..)

import Utils exposing (..)
import Plane exposing (basic2D)

main = basic2D
    { pixPerSide = 500
    , unitsPerSide = 40
    , strokeWidth = 1.5
    , tickLength = 3
    , origin = { x = 20, y = 20 }
    }
    [ Line { xCof = -1, yCof = 1, rhs = -2 } Red
    , Line { xCof = -2, yCof = 1, rhs = -7 } Blue
    , Point { x = 5, y = 3 } Black
    ]
