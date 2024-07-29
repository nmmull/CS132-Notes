module PlaneIntersection exposing (..)

import Lib.Utils exposing (..)
import Lib.Space exposing (basic3D, Element(..))

main =
    let
        pln1 = Plane3D 2 3 4 2
        pln2 = Plane3D 1 1 3 2
        pln3 = Plane3D 1 3 2 -2
        pnt1 = Point3D 4 -2 0
    in
    basic3D
        [ Point pnt1 { color = Red, hasGuides = True }
        , Intersection pln1 pln2
        , Intersection pln1 pln3
        , Intersection pln2 pln3
        , Plane pln1 { color = Red, hasHatch = False }
        , Plane pln2 { color = Blue, hasHatch = False }
        , Plane pln3 { color = Green, hasHatch = False }
        ]
