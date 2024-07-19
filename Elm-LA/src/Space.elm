module Space exposing (..)
import Utils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html as H exposing (Html)
import Html.Attributes as HA

type alias Params a =
    { a
    | distance : Int
    , tilt : Float
    , rotation : Float
    , quadrantWidth : Int
    , viewBoxWidth : Int
    , sceneWidth : Int
    , sceneOrigin : { x : Int , y : Int }
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
        offsetX = space * toFloat (params.sceneOrigin.x)
        offsetY = space * toFloat (params.sceneOrigin.y)
        drawPt = perspective params (rotY params (rotZ params pt))
    in Point2D
        (drawPt.x * space + offsetX)
        (-drawPt.y * space + offsetY)

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

drawPoint : Params a -> Point3D -> Color -> List (Svg msg)
drawPoint params pt color =
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
    , mycircle params pt [ fill (stringFromColor color) , r rStr ]
    ]

drawPlane : Params a -> Plane3D -> Bool -> Color -> List (Svg msg)
drawPlane params pln hasHatch color =
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
            [ fill (stringFromColor color)
            , opacity "0.3"
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
    in [ poly ] ++ (if hasHatch then xlines ++ ylines else [])

type Element
    = Plane Plane3D Bool Color
    | Point Point3D Color

drawElement : Params a -> Element -> List (Svg msg)
drawElement params e =
    case e of
        Plane pln hasHatch color -> drawPlane params pln hasHatch color
        Point pt color -> drawPoint params pt color

drawScene : Params a -> List Element -> List (Svg msg)
drawScene params scene = List.concatMap (drawElement params) scene

basic3D : Params a -> List Element -> Html msg
basic3D params scene =
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
