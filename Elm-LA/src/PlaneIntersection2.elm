module PlaneIntersection2 exposing (..)

import Lib.Utils exposing (..)
import Lib.Space exposing (basic3D, Element(..))

main =
    let
        pln1 = Plane3D 1 2 0 1
        pln2 = Plane3D -1 -1 -1 -1
        pln3 = Plane3D 2 6 -1 1
        pnt1 = Point3D 3 -1 -1
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
