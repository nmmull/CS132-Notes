module Main exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes as A
import Svg exposing (..)
import Svg.Attributes exposing (..)

main = Browser.element
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view
  }

-- Model

type alias Model = ()

init : () -> ( Model, Cmd Msg )
init _ = ( (), Cmd.none )

-- Update

type alias Msg = ()

update : Msg -> Model -> ( Model, Cmd Msg )
update _ _ = ( (), Cmd.none )

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

-- View

constants =
    { width = 500
    , lineWidth = 1
    , tickLength = 3
    , tickSpace = 10
    }

axis : Bool -> List (Svg Msg)
axis isX =
    let
        w = constants.width
        lw = constants.lineWidth
        tl = constants.tickLength
        str = String.fromInt
        oStr = str (w // 2)
        rot = "rotate(-90 " ++ oStr ++ " " ++ oStr ++ ")"
        rotAttr =
            if isX
            then []
            else [ transform (rot ++ "") ]
        tick xPos =
            let
                tickAttr =
                    [ x1 (str xPos)
                    , y1 (str (w // 2))
                    , x2 (str xPos)
                    , y2 (str (w // 2 - tl))
                    , stroke "black"
                    ] ++ rotAttr
            in line tickAttr []
        ticks =
            let
                ts = constants.tickSpace
                numTicks = w // ts - 1
            in
            List.map (\x -> tick (x * ts)) (List.range 1 numTicks)
        axisAttr =
            [ x1 "0"
            , y1 (str (w // 2))
            , x2 (str w)
            , y2 (str (w // 2))
            , stroke "black"
            ] ++ rotAttr
    in [ line axisAttr [] ] ++ ticks

dots =
    let
        tsp = constants.tickSpace
        numDots = constants.width // tsp // 2 - 1
        str = String.fromInt
        pos =
            List.concatMap
                (\x ->
                    List.map
                        (\y -> (str (x * 2 * tsp), str (y * 2 * tsp)))
                        (List.range 1 numDots))
                (List.range 1 numDots)
        dot (x, y) = circle
            [ r "0.5"
            , cx x
            , cy y
            , fill "grey"
            ]
            []
    in List.map dot pos

shift : (Float, Float) -> (Float, Float)
shift (x, y) =
    let
        ts = toFloat constants.tickSpace
        offset = toFloat (constants.width // 2)
    in
    (x * ts + offset, -y * ts + offset)

-- ax + by = c
genLine : Float -> Float -> Float -> String -> List (Svg Msg)
genLine a b c color =
    let
        str = String.fromFloat
        w = toFloat (constants.width // constants.tickSpace)
        yVal x = (c - a * x) / b
        (sx, sy) = shift (-w / 2, yVal (-w / 2))
        (ex, ey) = shift (w / 2, yVal (w / 2))
        attr =
            [ x1 (str sx)
            , y1 (str sy)
            , x2 (str ex)
            , y2 (str ey)
            , stroke color
            ]
    in [ line attr [] ]

genPoint : Float -> Float -> String -> List (Svg Msg)
genPoint x y color =
    let
        str = String.fromFloat
        (px, py) = shift (x, y)
        pt = circle
            [ r "2.0"
            , cx (str px)
            , cy (str py)
            , fill color
            ]
            []
        (gxsx, gxsy) = shift (x, 0)
        (gex, gey) = shift (x, y)
        (gysx, gysy) = shift (0, y)
        guideX = line
            [ x1 (str gxsx)
            , y1 (str gxsy)
            , x2 (str gex)
            , y2 (str gey)
            , strokeDasharray "2"
            , stroke "grey"
            ]
            []
        guideY = line
            [ x1 (str gysx)
            , y1 (str gysy)
            , x2 (str gex)
            , y2 (str gey)
            , strokeDasharray "2"
            , stroke "grey"
            ]
            []
    in [ guideX, guideY, pt ]


graph2D : Html Msg
graph2D =
    let
        scene =
            List.concat
               [ axis True
               , axis False
               , dots
               , genLine 2.0 3.0 -6.0 "red"
               , genPoint 6.0 -6.0 "red"
               , genPoint 12.0 -10.0 "red"
               , genPoint -9.0 4.0 "red"
               ]
    in
    svg
        [ width "500"
        , height "500"
        , viewBox "0 0 500 500"
        ]
        scene


view : Model -> Html Msg
view _ = Html.div
    [ A.style "margin-left" "auto"
    , A.style "margin-right" "auto"
    , A.style "width" (String.fromInt (constants.width) ++ "px")
    ]
    [ graph2D ]
