module Lib.AsciiStepper exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Browser
import Array exposing (Array)

splitOn : a -> List a -> List (List a)
splitOn delim lns =
    let
        consNonempty x xs =
            if List.isEmpty x
            then xs
            else x :: xs
        base =
            { frames = []
            , curr = []
            }
        op ln data =
            if ln == delim then
                { frames = consNonempty data.curr data.frames
                , curr = []
                }
            else
                { frames = data.frames
                , curr = ln :: data.curr
                }
        out = List.foldr op base lns
    in consNonempty out.curr out.frames

frames : String -> String -> List String
frames delim s =
    let
        splits = splitOn delim (String.lines s)
        height = List.foldl max 1 (List.map List.length splits)
        pad ls = String.join "\n" ls ++ String.repeat (height - List.length ls) "\n"
    in List.map pad splits

type Msg
    = Next
    | Prev

type alias Model =
    { frames : Array String
    , currFrame : Int
    }

init : Array String -> Model
init fs =
    { frames = fs
    , currFrame = 0
    }

update : Msg -> Model -> Model
update msg model =
    let nextFrame i = modBy (Array.length model.frames) (model.currFrame + i) in
    case msg of
        Next ->  { model | currFrame = nextFrame 1 }
        Prev ->  { model | currFrame = nextFrame (-1) }

view : Model -> Html Msg
view model =
    let
        frm =
            case Array.get model.currFrame model.frames of
                Just x -> x
                Nothing -> "UH-OH"
        display =
            frm
            ++ "\n\n"
            ++ "("
            ++ String.fromInt (model.currFrame + 1)
            ++ "/"
            ++ String.fromInt (Array.length model.frames)
            ++ ")"
    in H.div []
        [ H.pre [] [ H.text display ]
        , H.button
            [ HE.onClick Prev ]
            [ H.text "◁" ]
        , H.button
            [ HE.onClick Next ]
            [ H.text "▷" ]
        ]

basicASCII : String -> String -> Program () Model Msg
basicASCII delim s =
    let
        frms = Array.fromList (frames delim s)
    in
        Browser.sandbox
            { init = init frms
            , update = update
            , view = view
            }
