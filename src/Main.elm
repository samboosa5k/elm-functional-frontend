module Main exposing (main)

import Array exposing (Array, fromList, push, toList)
import Browser exposing (Document)
import Dict exposing (Dict)
import Html exposing (Attribute, Html, div, h2, header, input, main_, nav, p, pre, section, span, text)
import Html.Attributes exposing (class, id, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Json
import Maybe exposing (Maybe)
import Parser exposing (..)
import Parser.Advanced exposing (andThen)
import Platform.Cmd as Cmd exposing (Cmd)


type alias TerminalSessionData =
    { id_ : String
    , commandHistory : List String
    , output : List ( String, String )
    }


cliOutput : List ( String, String ) -> List (Html msg)
cliOutput model =
    List.map (\( x, y ) -> p [] [ text (x ++ y) ]) model


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


cliInput : String -> (String -> msg) -> (Int -> msg) -> Html msg
cliInput model handleInput handleKeyDown =
    input
        [ class "terminal-input__field"
        , type_ "text"
        , value model
        , onInput handleInput
        , onKeyDown handleKeyDown
        ]
        []


handleKeyCode : Int -> Msg
handleKeyCode keyCode =
    case keyCode of
        13 ->
            Evaluate

        _ ->
            NoOp


cliSessionView : String -> TerminalSessionData -> Html Msg
cliSessionView activeTextInput model =
    div [ class "cli-session__block" ]
        [ div [ class "terminal-input__container" ]
            (cliOutput model.output)
        , cliInput activeTextInput
            Input
            handleKeyCode
        ]


initialSessionData : TerminalSessionData
initialSessionData =
    { id_ = "initial"
    , commandHistory = []
    , output = []
    }


type alias Model =
    { title : String
    , terminalCount : Int
    , focussedTerminalID : String
    , activeTextInput : String
    , terminalSessionsData : Dict String TerminalSessionData
    }



-- INIT


initialModel : Model
initialModel =
    { title = "~/jvterm"
    , terminalCount = 1
    , focussedTerminalID = "initial"
    , activeTextInput = ""
    , terminalSessionsData =
        Dict.fromList
            [ ( "initial", initialSessionData )
            ]
    }


createSession : String -> Model -> Model
createSession title model =
    { model | terminalCount = model.terminalCount + 1, terminalSessionsData = Dict.insert title { initialSessionData | id_ = title } model.terminalSessionsData }



-- MSG


type Msg
    = Init Model
    | NoOp
    | Input String
    | Evaluate
    | Clear
    | CreateSession
    | FocusSession String



-- UPDATE


commandParser : Parser Msg
commandParser =
    oneOf
        [ map (\_ -> Clear) (keyword "clear")
        , map (\_ -> CreateSession) (keyword "create")
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init model_ ->
            ( model_, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        Input typedValue ->
            ( { model | activeTextInput = typedValue }, Cmd.none )

        Evaluate ->
            let
                parsedCommand =
                    Parser.run commandParser model.activeTextInput
            in
            case parsedCommand of
                Ok command ->
                    update command model

                Err _ ->
                    let
                        sessionModel =
                            getSessionData model

                        evaluatedSessionModel =
                            { sessionModel | output = sessionModel.output ++ [ ( model.activeTextInput, ": command not found" ) ] }
                    in
                    ( { model
                        | activeTextInput = ""
                        , terminalSessionsData = Dict.insert model.focussedTerminalID evaluatedSessionModel model.terminalSessionsData
                      }
                    , Cmd.none
                    )

        Clear ->
            let
                sessionModel =
                    getSessionData model

                clearedSessionModel =
                    { sessionModel | output = [] }
            in
            ( { model
                | activeTextInput = ""
                , terminalSessionsData = Dict.insert model.focussedTerminalID clearedSessionModel model.terminalSessionsData
              }
            , Cmd.none
            )

        CreateSession ->
            let
                newModel =
                    createSession (String.fromInt model.terminalCount) model
            in
            ( newModel, Cmd.none )

        FocusSession id_ ->
            ( { model | focussedTerminalID = id_ }, Cmd.none )



-- VIEW


getSessionData : Model -> TerminalSessionData
getSessionData { focussedTerminalID, terminalSessionsData } =
    Dict.get focussedTerminalID terminalSessionsData
        |> Maybe.withDefault initialSessionData


terminalSessionList : List TerminalSessionData -> List (Html Msg)
terminalSessionList terminalSessionsData =
    List.map (\terminalSessionData -> span [ onClick (FocusSession terminalSessionData.id_) ] [ text terminalSessionData.id_ ]) terminalSessionsData


view : Model -> Document Msg
view model =
    { title = model.title
    , body =
        [ pre
            [ id "app" ]
            [ header [ class "header__container" ]
                [ div [ class "title-bar__container" ]
                    [ h2 [ class "title-bar__heading" ] [ text "jvterm" ]
                    ]
                ]
            , nav [ class "nav-menu__container" ]
                [ section [ class "nav-menu__list" ]
                    (terminalSessionList (Dict.values model.terminalSessionsData))
                ]
            , main_ []
                [ section [ class "cli-session__container" ]
                    [ cliSessionView
                        model.activeTextInput
                        (getSessionData model)
                    ]
                ]
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
