module PlaneIntersectionTwo exposing (..)

import Lib.Utils exposing (Point3D, Plane3D, Color(..))
import Lib.Space exposing (basic3D, Element(..))
import Browser
import Time
import Html exposing (Html)

type alias Model =
    { distance : Int
    , tilt : Float
    , rotation : Float
    , viewBoxWidth : Int
    , quadrantWidth : Int
    , sceneWidth : Int
    , sceneOrigin : { x : Int, y : Int }
    , strokeWidth : Float
    }

type Msg = Tick Time.Posix

init : () -> ( Model, Cmd Msg )
init _ =
    ( { distance = 50
      , tilt = 0.2
      , rotation = 0
      , viewBoxWidth = 500
      , quadrantWidth = 15
      , sceneWidth = 42
      , sceneOrigin = { x = 21, y = 21 }
      , strokeWidth = 1
      }
    , Cmd.none
    )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let newRot = if model.rotation < 100 then model.rotation + 0.01 else 0 in
    case msg of
        Tick _ -> ( { model | rotation = newRot}, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions _ = Time.every 30 Tick

view : Model -> Html Msg
view model =
    let
        pln1 = Plane3D 2 1 -3 3
        pln2 = Plane3D 1 -1 3 3
        pnt1 = Point3D 2 5 2
        pnt2 = Point3D 2 -5.5 -1.5
    in
    basic3D model
        [ Point pnt1 { color = Red, hasGuides = True }
        , Point pnt2 { color = Red, hasGuides = True }
        , Intersection pln1 pln2
        , Plane pln1 { color = Red, hasHatch = False }
        , Plane pln2 { color = Blue, hasHatch = False }
        ]

main = Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
