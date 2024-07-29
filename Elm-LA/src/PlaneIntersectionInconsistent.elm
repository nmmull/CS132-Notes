module PlaneIntersectionInconsistent exposing (..)

import Lib.Utils exposing (..)
import Lib.Space exposing (basic3D, Element(..))

main =
    let
        pln1 = Plane3D 1 0 1 2
        pln2 = Plane3D 1 0 -1 -2
        pln3 = Plane3D 0 0 1 -2
    in
    basic3D
        [ Intersection pln1 pln2
        , Intersection pln1 pln3
        , Intersection pln2 pln3
        , Plane pln1 { color = Red, hasHatch = False }
        , Plane pln2 { color = Blue, hasHatch = False }
        , Plane pln3 { color = Green, hasHatch = False }
        ]
