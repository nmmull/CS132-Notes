module ExamplePlane exposing (..)

import Utils exposing (Point3D, Plane3D, Color(..))
import Space exposing (basic3D, Element(..))
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
      , quadrantWidth = 20
      , sceneWidth = 60
      , sceneOrigin = { x = 30, y = 30 }
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
        pln = Plane3D 1 1 1 1
        p1 = Point3D 4 3 -6
        p2 = Point3D -3 -5 9
        p3 = Point3D -8 8 1
    in
    basic3D model
        [ Plane pln True Red
        , Point p1 Red
        , Point p2 Red
        , Point p3 Red
        ]

main = Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
