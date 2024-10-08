module Lib.Space exposing (..)

import Lib.Utils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html as H exposing (Html)
import Html.Attributes as HA

import Browser exposing (element)
import Time

type alias Params a =
    { a
    | distance : Int
    , tilt : Float
    , rotation : Float
    , quadrantWidth : Int
    , viewBoxWidth : Int
    , sceneWidth : Int
    , strokeWidth : Float
    }

minC : Params a -> Float
minC params = -(toFloat params.quadrantWidth)

maxC : Params a -> Float
maxC params = toFloat params.quadrantWidth

rotZ : Params a -> Point3D -> Point3D
rotZ params pt =
    let theta = params.rotation in
    Point3D
        (cos theta * pt.x - sin theta * pt.y)
        (sin theta * pt.x + cos theta * pt.y)
        pt.z

rotY : Params a -> Point3D -> Point3D
rotY params pt =
    let theta = params.tilt in
    Point3D
        (cos theta * pt.x + sin theta * pt.z)
        pt.y
        (-(sin theta) * pt.x + cos theta * pt.z)

perspective : Params a -> Point3D -> Point2D
perspective params pt =
    let d = toFloat params.distance in
    Point2D
        (pt.y / (1 - pt.x / d))
        (pt.z / (1 - pt.x / d))

shift : Params a -> Point3D -> Point2D
shift params pt =
    let
        w = toFloat params.viewBoxWidth
        space = w / toFloat params.sceneWidth
        offset = space * toFloat params.sceneWidth / 2
        drawPt = perspective params (rotY params (rotZ params pt))
    in Point2D
        (drawPt.x * space + offset)
        (-drawPt.y * space + offset)

myline : Params a -> Point3D -> Point3D -> List (Attribute msg) -> Svg msg
myline params p1 p2 baseAttrs =
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
    in line (endpoints ++ baseAttrs) []

mycircle : Params a -> Point3D -> List (Attribute msg) -> Svg msg
mycircle params pt baseAttrs =
    let
        center = shift params pt
        str = String.fromFloat
        attr =
            [ cx (str center.x)
            , cy (str center.y)
            ]
    in circle (attr ++ baseAttrs) []

drawAxis : Params a -> List (Svg msg)
drawAxis params =
    let
        str = String.fromFloat
        baseAttrs =
            [ stroke "black"
            , strokeWidth (str params.strokeWidth)
            ]
        axis p1 p2 = myline params p1 p2 baseAttrs
        mnC = minC params
        mxC = maxC params
    in
    [ axis (Point3D mnC 0 0) (Point3D mxC 0 0)
    , axis (Point3D 0 mnC 0) (Point3D 0 mxC 0)
    , axis (Point3D 0 0 mnC) (Point3D 0 0 mxC)
    , mycircle params (Point3D mxC 0 0) [ r (str (params.strokeWidth * 2)), fill "black" ]
    ]

mypolygon : Params a -> List Point3D -> List (Attribute msg) -> Svg msg
mypolygon params pts baseAttrs =
    let
        drawPts = List.map (shift params) pts
        str = String.fromFloat
        strPts =
            String.join " "
                (List.map (\p -> str p.x ++ "," ++ str p.y)
                    drawPts)

    in
    polygon (points strPts :: baseAttrs) []

drawPoint : Params a -> Point3D -> Point3DStyle -> List (Svg msg)
drawPoint params pt sty =
    let
        rStr = String.fromFloat (params.strokeWidth * 2)
        guide p1 p2 = myline params p1 p2
            [ stroke "grey"
            , strokeDasharray rStr
            , strokeWidth (String.fromFloat (params.strokeWidth / 2))
            ]
    in
    [ guide (Point3D pt.x 0 0) (Point3D pt.x pt.y 0)
    , guide (Point3D pt.x pt.y 0) pt
    , guide (Point3D 0 pt.y 0) (Point3D pt.x pt.y 0)
    , guide (Point3D 0 0 pt.z) (Point3D 0 pt.y pt.z)
    , guide (Point3D 0 pt.y pt.z) pt
    , guide (Point3D pt.x 0 pt.z) pt
    , guide (Point3D 0 0 pt.z) (Point3D pt.x 0 pt.z)
    , guide (Point3D pt.x 0 0) (Point3D pt.x 0 pt.z)
    , guide (Point3D 0 pt.y 0) (Point3D 0 pt.y pt.z)
    , mycircle params pt [ fill (stringFromColor sty.color) , r rStr ]
    ]

error : Float
error =  0.000000001

isZero : Float -> Bool
isZero x = abs x < error

inBounds : Params a -> Float -> Bool
inBounds params x = x > minC params / 2 - error && x < maxC params / 2 + error

drawVPlane : Params a -> Plane3D -> Plane3DStyle -> List (Svg msg)
drawVPlane params pln sty =
    let
        mnC = minC params / 2
        mxC = maxC params / 2
        yVal x = (pln.rhs - pln.xCof * x) / pln.yCof
        xVal y = (pln.rhs - pln.yCof * y) / pln.xCof
        ends =
            if isZero pln.xCof then
                [ ( mnC, pln.rhs / pln.yCof )
                , ( mxC, pln.rhs / pln.yCof )
                ]
            else if isZero pln.yCof then
                [ ( pln.rhs / pln.xCof, mnC )
                , ( pln.rhs / pln.xCof, mxC )
                ]
            else
                [ ( mnC, yVal mnC )
                , ( mxC, yVal mxC )
                , ( xVal mnC, mnC )
                , ( xVal mxC, mxC )
                ]
        filtered_ends =
            List.filter (\(x, y) -> inBounds params x && inBounds params y) ends
        mkEdge (x, y) = [ Point3D x y (mnC * 2.5), Point3D x y (mxC * 2.5) ]
        points =
            case filtered_ends of
                p1 :: p2 :: [] ->
                    mkEdge p1 ++ List.reverse (mkEdge p2)
                _ -> [] -- IMPOSSIBLE
        poly = mypolygon
            params
            points
            [ fill (stringFromColor sty.color)
            , opacity "0.27"
            , stroke "black"
            ]
    in
        [ poly ]

drawNVPlane : Params a -> Plane3D -> Plane3DStyle -> List (Svg msg)
drawNVPlane params pln sty =
    let
        zVal x y = (pln.rhs - pln.xCof * x - pln.yCof * y) / pln.zCof
        mnC = minC params / 2
        mxC = maxC params / 2
        pts =
            [ Point3D mnC mnC (zVal mnC mnC)
            , Point3D mnC mxC (zVal mnC mxC)
            , Point3D mxC mxC (zVal mxC mxC)
            , Point3D mxC mnC (zVal mxC mnC)
            ]
        poly = mypolygon
            params
            pts
            [ fill (stringFromColor sty.color)
            , opacity "0.27"
            , stroke "black"
            ]
        xline x = myline
            params
            (Point3D x mnC (zVal x mnC))
            (Point3D x mxC (zVal x mxC))
            [ strokeWidth (String.fromFloat params.strokeWidth)
            , stroke "black"
            , opacity "0.1"
            ]
        xlines =
            List.map
                (\x -> xline (toFloat x))
                (List.range (ceiling mnC + 1) (floor mxC - 1))
        yline y = myline
            params
            (Point3D mnC y (zVal mnC y))
            (Point3D mxC y (zVal mxC y))
            [ strokeWidth (String.fromFloat params.strokeWidth)
            , stroke "black"
            , opacity "0.1"
            ]
        ylines =
            List.map
                (\y -> yline (toFloat y))
                (List.range (ceiling mnC + 1) (floor mxC - 1))
    in [ poly ] ++ (if sty.hasHatch then xlines ++ ylines else [])

drawPlane params pln sty =
    if isZero (pln.zCof) then
        drawVPlane params pln sty
    else
        drawNVPlane params pln sty

getInterByX : Params a -> Plane3D -> Plane3D -> Float -> Maybe Point3D
getInterByX params pln1 pln2 x =
    let
        a = ( pln1.xCof, pln2.xCof )
        b = ( pln1.yCof, pln2.yCof )
        c = ( pln1.zCof, pln2.zCof )
        d = ( pln1.rhs, pln2.rhs )
        det ( e1, e2 ) ( f1, f2 ) = e1 * f2 - f1 * e2
        mxC = maxC params / 2
        y = -(det c d + (det a c) * x)
        z = (det b d + (det a b) * x)
    in
        if not (isZero (det b c)) && abs (y / det b c) <= mxC + error
        then Just (Point3D x (y / det b c) (z / det b c))
        else Nothing

getInterByY : Params a -> Plane3D -> Plane3D -> Float -> Maybe Point3D
getInterByY params pln1 pln2 yVal =
    let
        pln11 = Plane3D pln1.yCof pln1.xCof pln1.zCof pln1.rhs
        pln22 = Plane3D pln2.yCof pln2.xCof pln2.zCof pln2.rhs
        swap { x, y, z } = Point3D y x z
   in Maybe.map swap (getInterByX params pln11 pln22 yVal)

intersections : Params a -> Plane3D -> Plane3D -> List Point3D
intersections params pln1 pln2 =
    let
        toList m =
            case m of
                Nothing -> []
                Just a -> [a]
        mxC = maxC params / 2
        mnC = minC params / 2
        det = pln1.xCof * pln2.yCof - pln1.yCof * pln2.xCof
        checkV =
            isZero pln1.zCof
            && isZero pln2.zCof
            && not (isZero det)
    in
    if checkV then
        let
            xInt = (pln2.yCof * pln1.rhs - pln2.xCof * pln2.rhs) / det
            yInt = (pln1.xCof * pln2.rhs - pln2.xCof * pln1.rhs) / det
        in
        [ Point3D xInt yInt (mnC * 2.5)
        , Point3D xInt yInt (mxC * 2.5)
        ]
    else
        List.concatMap toList
            [ getInterByX params pln1 pln2 mnC
            , getInterByX params pln1 pln2 mxC
            , getInterByY params pln1 pln2 mnC
            , getInterByY params pln1 pln2 mxC
            ]

drawIntersection : Params a -> Plane3D -> Plane3D -> List (Svg msg)
drawIntersection params pln1 pln2 =
    case intersections params pln1 pln2 of
        x :: y :: [] ->
            [ myline params x y
                [ stroke "grey"
                , strokeWidth (String.fromFloat params.strokeWidth)
                ]
            ]
        _ -> []

type Element
    = Plane Plane3D Plane3DStyle
    | Point Point3D Point3DStyle
    | Intersection Plane3D Plane3D

drawElement : Params a -> Element -> List (Svg msg)
drawElement params e =
    case e of
        Plane pln sty -> drawPlane params pln sty
        Point pt sty -> drawPoint params pt sty
        Intersection pln1 pln2 -> drawIntersection params pln1 pln2

drawScene : Params a -> List Element -> List (Svg msg)
drawScene params scene = List.concatMap (drawElement params) scene

basic3DHtml : Params a -> List Element -> Html msg
basic3DHtml params scene =
    let w = String.fromInt params.viewBoxWidth in
    H.div
        [ HA.style "margin-left" "auto"
        , HA.style "margin-right" "auto"
        , HA.style "width" (w ++ "px")
        ]
        [ svg
            [ width w
            , height w
            , viewBox ("0 0 " ++ w ++ " " ++ w)
            ]
            (drawAxis params ++ drawScene params scene)
        ]


type alias BasicModel =
    { distance : Int
    , tilt : Float
    , rotation : Float
    , quadrantWidth : Int
    , viewBoxWidth : Int
    , sceneWidth : Int
    , strokeWidth : Float
    }


type BasicMsg = Tick Time.Posix

basicInit : () -> ( BasicModel, Cmd BasicMsg )
basicInit _ =
    ( { distance = 50
      , tilt = 0.2
      , rotation = 0
      , viewBoxWidth = 500
      , quadrantWidth = 20
      , sceneWidth = 60
      , strokeWidth = 1
      }
    , Cmd.none
    )

basicUpdate : BasicMsg -> BasicModel -> ( BasicModel, Cmd BasicMsg )
basicUpdate msg model =
    let newRot = if model.rotation < 100 then model.rotation + 0.01 else 0 in
    case msg of
        Tick _ -> ( { model | rotation = newRot}, Cmd.none )

basicSubs : BasicModel -> Sub BasicMsg
basicSubs _ = Time.every 30 Tick

basicView : List Element -> BasicModel -> Html BasicMsg
basicView scene model =
    basic3DHtml model scene

basic3D : List Element -> Program () BasicModel BasicMsg
basic3D scene = Browser.element
    { init = basicInit
    , update = basicUpdate
    , subscriptions = basicSubs
    , view = basicView scene
    }
