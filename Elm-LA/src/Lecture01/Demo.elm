module Lecture01.Demo exposing (..)

import Lib.Utils exposing (..)
import Lib.Space exposing (basic3D, Element(..))

main =
    let
        p1 = Point3D 0 0 5
        p2 = Point3D 0 -5 0
        p3 = Point3D -5 0 0
        pntSty = { color = Red, hasGuides = True }
        pln = Plane3D -1 -1 1 5
        plnSty = { color = Red, hasHatch = True }
    in
    basic3D
        [ Plane pln plnSty
        , Point p1 pntSty
        , Point p2 pntSty
        , Point p3 pntSty
        ]
