module Utils exposing (..)

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

type alias Point3D =
    { x : Float
    , y : Float
    , z : Float
    }

type Color
    = Red
    | Blue
    | Green

stringFromColor : Color -> String
stringFromColor c =
    case c of
        Red -> "red"
        Blue -> "blue"
        Green -> "green"

type Element2D
    = Point Point2D Color
    | Line Line2D Color
