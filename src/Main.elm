module Main exposing (main)

import Array exposing (Array, fromList, push, toList)
import Browser exposing (Document)
import Dict exposing (Dict)
import Html exposing (main_, pre, text)
import Html.Attributes exposing (id)
import List.Extra
import Parser exposing (..)
import Platform.Cmd as Cmd exposing (Cmd)
import Terminal exposing (Command, commandParser)
import Url.Parser as Parser



-- type alias Model =
--     { terminalSessions : List Terminal.Model
--     }
-- initialState : Model
-- initialState =
--     { terminalSessions =
--         [ Terminal.initNew 0
--         , Terminal.initNew 1
--         , Terminal.initNew 2
--         , Terminal.initNew 3
--         ]
--     }
-- type Msg
--     = NoOp
--     | TerminalSession Int Terminal.Msg
--     | Evaluate Int Terminal.Msg
--     | CreateSession
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         NoOp ->
--             ( model, Cmd.none )
--         Evaluate id_ sessionMsg ->
--             let
--                 maybeIndex =
--                     List.Extra.findIndex (\sessionData -> sessionData.id_ == id_) model.terminalSessions
--                 index =
--                     case maybeIndex of
--                         Just indexNr ->
--                             indexNr
--                         Nothing ->
--                             -1
--                 selectedInput =
--                     case List.Extra.getAt index model.terminalSessions of
--                         Just sessionInput ->
--                             sessionInput
--                         Nothing ->
--                             Terminal.initNew 0
--             in
--             if selectedInput.evaluate == True then
--                 let
--                     ( updatedInput, cmdMsg ) =
--                         Terminal.update sessionMsg { selectedInput | evaluate = False }
--                     inputs =
--                         List.Extra.setAt index updatedInput model.terminalSessions
--                     newID =
--                         List.maximum (List.map (\x -> x.id_) model.terminalSessions)
--                     newModel =
--                         Terminal.initNew (Maybe.withDefault 0 newID)
--                 in
--                 ( { model | terminalSessions = toList (push newModel (fromList inputs)) }, Cmd.map (TerminalSession id_) cmdMsg )
--             else
--                 -- do update only
--                 let
--                     ( updatedInput, cmdMsg ) =
--                         Terminal.update sessionMsg selectedInput
--                     inputs =
--                         List.Extra.setAt index updatedInput model.terminalSessions
--                 in
--                 ( { model | terminalSessions = inputs }, Cmd.map (TerminalSession id_) cmdMsg )
--         TerminalSession id_ sessionMsg ->
--             -- REFERENCE: https://blog.revathskumar.com/2018/05/elm-message-passing-between-modules.html
--             -- ARTICLE AUTHOR: https://github.com/revathskumar\
--             let
--                 maybeIndex =
--                     List.Extra.findIndex (\sessionData -> sessionData.id_ == id_) model.terminalSessions
--                 index =
--                     case maybeIndex of
--                         Just indexNr ->
--                             indexNr
--                         Nothing ->
--                             -1
--                 selectedInput =
--                     case List.Extra.getAt index model.terminalSessions of
--                         Just sessionInput ->
--                             sessionInput
--                         Nothing ->
--                             Terminal.initNew 0
--                 -- Before upating input and running msg, evaluate the submitted command
--                 ( updatedInput, cmdMsg ) =
--                     Terminal.update sessionMsg selectedInput
--                 inputs =
--                     List.Extra.setAt index updatedInput model.terminalSessions
--             in
--             ( { model | terminalSessions = inputs }, Cmd.map (TerminalSession id_) cmdMsg )
--         CreateSession ->
--             let
--                 newID =
--                     List.maximum (List.map (\x -> x.id_) model.terminalSessions)
--                 newModel =
--                     Terminal.initNew (Maybe.withDefault 0 newID)
--             in
--             ( { model | terminalSessions = toList (push newModel (fromList model.terminalSessions)) }, Cmd.none )
-- view : Model -> Document Msg
-- view { terminalSessions } =
--     { title =
--         "~/jvterm"
--     , body =
--         [ pre
--             [ id "app" ]
--             [ main_ []
--                 (Terminal.view terminalSessions Evaluate)
--             ]
--         ]
--     }
-- subscriptions : Model -> Sub Msg
-- subscriptions _ =
--     Sub.none
-- main : Program () Model Msg
-- main =
--     Browser.document
--         { init = \_ -> ( initialState, Cmd.none )
--         , subscriptions = subscriptions
--         , update = update
--         , view = view
--         }
-- BIG REFACTORING
-- MODEL


type alias TerminalSessionData =
    { id_ : String
    , commandHistory : List String
    , output : List ( String, String )
    }


initialSessionData : TerminalSessionData
initialSessionData =
    { id_ = "initial"
    , commandHistory = []
    , output = []
    }


terminalSessions : Dict String TerminalSessionData
terminalSessions =
    Dict.fromList
        [ ( "initial", initialSessionData )
        ]


type alias Model =
    { title : String
    , terminalCount : Int
    , focussedTerminalID : String
    , focussedTerminalInput : String
    , terminalSessionsData : Dict String TerminalSessionData
    }



-- INIT


initialModel : Model
initialModel =
    { title = "~/jvterm"
    , terminalCount = 1
    , focussedTerminalID = "initial"
    , focussedTerminalInput = ""
    , terminalSessionsData = terminalSessions
    }



-- MSG


type Msg
    = Init_ Model
    | NoOp_



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init_ model_ ->
            ( model_, Cmd.none )

        NoOp_ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    { title = model.title
    , body =
        [ pre
            [ id "app" ]
            [ main_ []
                [ text "Hello" ]
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> ( initialModel, Cmd.none )
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
