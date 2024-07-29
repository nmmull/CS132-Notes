module ExamplePlane exposing (..)

import Lib.Utils exposing (..)
import Lib.Space exposing (basic3D, Element(..))

main =
    let
        pln = Plane3D 1 1 1 1
        plnSty = { color = Red, hasHatch = True }
        p1 = Point3D 4 3 -6
        p2 = Point3D -3 -5 9
        p3 = Point3D -8 8 1
        pntSty = { color = Red, hasGuides = True }
    in
    basic3D
        [ Plane pln plnSty
        , Point p1 pntSty
        , Point p2 pntSty
        , Point p3 pntSty
        ]
