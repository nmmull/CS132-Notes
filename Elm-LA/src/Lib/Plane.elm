module Lib.Plane exposing (..)

import Html exposing (Html)
import Html.Attributes as HA
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Lib.Utils exposing (..)

type alias Params a =
    { a
    | pixPerSide : Float
    , strokeWidth : Float
    , tickLength : Float
    , unitsPerSide : Int
    , origin : { x : Int, y : Int }
    }

type alias PlaneParams =
    { pixPerSide : Float
    , strokeWidth : Float
    , tickLength : Float
    , unitsPerSide : Int
    }

tickSpace : Params a -> Float
tickSpace { pixPerSide, unitsPerSide } = pixPerSide / toFloat unitsPerSide

numTicks : Params a -> Int
numTicks { unitsPerSide } = unitsPerSide - 1

originPt params = shift params (Point2D 0 0)

xAxis : Params a -> List (Svg b)
xAxis params =
    let
        w = params.pixPerSide
        sw = params.strokeWidth
        tl = params.tickLength
        str = String.fromFloat
        yPos = (originPt params).y
        tick x =
            line
                [ x1 (str x)
                , y1 (str yPos)
                , x2 (str x)
                , y2 (str (yPos - tl))
                , stroke "black"
                , strokeWidth (str sw)
                ]
                []
        ticks =
            List.map
                (\x -> tick (toFloat x * tickSpace params))
                (List.range 1 (numTicks params))
    in
        [ line
            [ x1 "0"
            , y1 (str yPos)
            , x2 (str w)
            , y2 (str yPos)
            , stroke "black"
            , strokeWidth (str sw)
            ]
            []
        ] ++ ticks

-- UGLY
yAxis : Params a -> List (Svg b)
yAxis params =
    let
        w = params.pixPerSide
        sw = params.strokeWidth
        tl = params.tickLength
        str = String.fromFloat
        xPos = (originPt params).x
        tick y =
            line
                [ x1 (str xPos)
                , y1 (str y)
                , x2 (str (xPos - tl))
                , y2 (str y)
                , stroke "black"
                , strokeWidth (str sw)
                ]
                []
        ticks =
            List.map
                (\x -> tick (toFloat x * tickSpace params))
                (List.range 1 (numTicks params))
    in
        [ line
            [ x1 (str xPos)
            , y1 "0"
            , x2 (str xPos)
            , y2 (str w)
            , stroke "black"
            , strokeWidth (str sw)
            ]
            []
        ] ++ ticks

numDots : Params a -> Int
numDots params = params.unitsPerSide // 2 - 1

dotSpace : Params a -> Float
dotSpace params = 2 * tickSpace params

dots : Params a -> List (Svg b)
dots params =
    let
        str = String.fromFloat
        pos =
            List.concatMap (\x ->
                List.map (\y ->
                    ( str (toFloat x * dotSpace params)
                    , str (toFloat y * dotSpace params)
                    ))
                    (List.range 1 (numDots params)))
                (List.range 1 (numDots params))
        dot (x, y) = circle
            [ r (str (params.strokeWidth / 2))
            , cx x
            , cy y
            , fill "grey"
            ] []
    in List.map dot pos

drawPlane : Params a -> List (Svg b)
drawPlane params =
    List.concatMap
        (\f -> f params)
        [ dots, xAxis, yAxis ]

shift : Params a -> Point2D -> Point2D
shift params { x, y } =
    let
        ts = tickSpace params
        offsetX = tickSpace params * toFloat params.origin.x
        offsetY = tickSpace params * toFloat params.origin.y
    in Point2D (x * ts + offsetX) (-y * ts + offsetY)

myline : Params a -> Point2D -> Point2D -> List (Attribute msg) -> List (Svg msg)
myline params p1 p2 baseAttr =
    let
        str = String.fromFloat
        start = shift params p1
        end = shift params p2
        endpoints =
            [ x1 (str start.x)
            , y1 (str start.y)
            , x2 (str end.x)
            , y2 (str end.y)
            ]
    in [ line (endpoints ++ baseAttr) [] ]

mycircle : Params a -> Point2D -> List (Attribute msg) -> List (Svg msg)
mycircle params p baseAttr =
    let
        str = String.fromFloat
        center = shift params p
        centerAttr =
            [ cx (str center.x)
            , cy (str center.y)
            ]
    in [ circle (centerAttr ++ baseAttr) [] ]

minC : Params a -> Float
minC params = -(toFloat (params.unitsPerSide // 2))

maxC : Params a -> Float
maxC params = toFloat (params.unitsPerSide // 2)

drawLine : Params a -> Line2D -> Color -> List (Svg b)
drawLine params ln color =
    let
        str = String.fromFloat
        yVal x = (ln.rhs - ln.xCof * x) / ln.yCof
        minX = minC params
        maxX = maxC params
    in
        myline
            params
            (Point2D minX (yVal minX))
            (Point2D maxX (yVal maxX))
            [ stroke (stringFromColor color)
            , strokeWidth (str params.strokeWidth)
            ]

drawPoint : Params a -> Point2D -> Color -> List (Svg b)
drawPoint params point color =
    let
        str = String.fromFloat
        dot = mycircle
            params
            point
            [ r (str (params.strokeWidth * 2))
            , fill (stringFromColor color)
            ]
        xStart = Point2D point.x 0
        yStart = Point2D 0 point.y
        guideX = myline
            params
            xStart
            point
            [ strokeDasharray (str (params.strokeWidth * 2))
            , stroke "grey"
            ]
        guideY = myline
            params
            yStart
            point
            [ strokeDasharray (str (params.strokeWidth * 2))
            , stroke "grey"
            ]
    in guideX ++ guideY ++ dot

type Element
    = Point Point2D Color
    | Line Line2D Color

drawElement : Params a -> Element -> List (Svg msg)
drawElement params e =
    case e of
        Line ln color -> drawLine params ln color
        Point pt color -> drawPoint params pt color

drawScene : Params a -> List Element -> List (Svg msg)
drawScene params scene = List.concatMap (drawElement params) scene

basic2D : Params a -> List Element -> Html msg
basic2D params scene =
    let w = String.fromFloat params.pixPerSide in
    Html.div
        [ HA.style "margin-left" "auto"
        , HA.style "margin-right" "auto"
        , HA.style "width" (w ++ "px")
        ]
        [ svg
            [ width w
            , height w
            , viewBox ("0 0 " ++ w ++ " " ++ w)
            ]
            (drawPlane params ++ drawScene params scene)
        ]
