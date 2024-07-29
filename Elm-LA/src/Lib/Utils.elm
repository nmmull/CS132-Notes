module Lib.Utils exposing (..)

import Html exposing (Html, div)
import Html.Attributes as A
import Svg exposing (Svg, svg)
import Svg.Attributes as SA

type alias Point2D =
    { x : Float
    , y : Float
    }

type alias Line2D =
    { xCof : Float
    , yCof : Float
    , rhs : Float
    }

type alias Plane3D =
    { xCof : Float
    , yCof : Float
    , zCof : Float
    , rhs : Float
    }

type alias Plane3DStyle =
    { color : Color
    , hasHatch : Bool
    }

type alias Point3D =
    { x : Float
    , y : Float
    , z : Float
    }

type alias Point3DStyle =
    { color : Color
    , hasGuides : Bool
    }

type Color
    = Red
    | Blue
    | Green
    | Black
    | Grey

stringFromColor : Color -> String
stringFromColor c =
    case c of
        Red -> "red"
        Blue -> "blue"
        Green -> "green"
        Black -> "black"
        Grey -> "grey"

type Element2D
    = Point Point2D Color
    | Line Line2D Color
