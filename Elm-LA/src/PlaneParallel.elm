module PlaneParallel exposing (..)

import Lib.Utils exposing (..)
import Lib.Space exposing (basic3D, Element(..))

main =
    let
        pln1 = Plane3D 1 1 2 -3
        pln2 = Plane3D 1 1 2 6
    in
    basic3D
        [ Plane pln1 { color = Red, hasHatch = True }
        , Plane pln2 { color = Blue, hasHatch = True }
        ]
