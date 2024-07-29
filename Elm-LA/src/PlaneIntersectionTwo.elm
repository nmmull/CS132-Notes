module PlaneIntersectionTwo exposing (..)

import Lib.Utils exposing (..)
import Lib.Space exposing (basic3D, Element(..))

main =
    let
        pln1 = Plane3D 2 1 -3 3
        pln2 = Plane3D 1 -1 3 3
        pnt1 = Point3D 2 5 2
        pnt2 = Point3D 2 -5.5 -1.5
    in
    basic3D
        [ Point pnt1 { color = Red, hasGuides = True }
        , Point pnt2 { color = Red, hasGuides = True }
        , Intersection pln1 pln2
        , Plane pln1 { color = Red, hasHatch = False }
        , Plane pln2 { color = Blue, hasHatch = False }
        ]
