module Main exposing (main)

import Array exposing (fromList)
import Browser exposing (Document)
import Dict exposing (Dict)
import Html exposing (Attribute, Html, div, h2, header, input, main_, nav, p, pre, section, span, text)
import Html.Attributes exposing (class, id, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Json
import Maybe
import Parser exposing (..)
import Platform.Cmd as Cmd exposing (Cmd)


type alias TerminalSessionData =
    { sessionId : String
    , commandHistory : List String
    , output : List ( String, String )
    }


generateCliOutput : List ( String, String ) -> List (Html msg)
generateCliOutput model =
    List.map (\( x, y ) -> p [] [ text (x ++ y) ]) model


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


generateCliInput : String -> (String -> msg) -> (Int -> msg) -> Html msg
generateCliInput model handleInput handleKeyDown =
    input
        [ class "terminal-input__field"
        , type_ "text"
        , value model
        , onInput handleInput
        , onKeyDown handleKeyDown
        ]
        []


handleInputKeyCode : Int -> Msg
handleInputKeyCode keyCode =
    case keyCode of
        13 ->
            Evaluate

        _ ->
            NoOp


generateCliSessionView : String -> TerminalSessionData -> Html Msg
generateCliSessionView activeTextInput model =
    div [ class "cli-session__block" ]
        [ div [ class "terminal-input__container" ]
            (generateCliOutput model.output)
        , generateCliInput activeTextInput
            Input
            handleInputKeyCode
        ]


initialSessionData : TerminalSessionData
initialSessionData =
    { sessionId = "initial"
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


createNewSession : String -> Model -> Model
createNewSession title model =
    { model
        | terminalCount = model.terminalCount + 1
        , terminalSessionsData =
            Dict.insert title
                { initialSessionData
                    | sessionId = title
                }
                model.terminalSessionsData
    }



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


cliCommandParser : Parser Msg
cliCommandParser =
    oneOf
        [ map (\_ -> Clear) (keyword "clear")
        , map (\_ -> CreateSession) (keyword "create")
        ]



-- Helper function to update terminalSessionsData


updateTerminalSessionsData : String -> (TerminalSessionData -> TerminalSessionData) -> Model -> Model
updateTerminalSessionsData id_ updateFn model =
    { model | terminalSessionsData = Dict.update id_ (Maybe.map updateFn) model.terminalSessionsData }


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
                    Parser.run cliCommandParser model.activeTextInput

                sessionModel =
                    getActiveSessionData model
            in
            case parsedCommand of
                Ok command ->
                    update command model

                Err _ ->
                    let
                        evaluatedSessionModel =
                            { sessionModel | output = sessionModel.output ++ [ ( model.activeTextInput, ": command not found" ) ] }
                    in
                    ( updateTerminalSessionsData model.focussedTerminalID (\_ -> evaluatedSessionModel) model, Cmd.none )

        Clear ->
            let
                sessionModel =
                    getActiveSessionData model

                clearedSessionModel =
                    { sessionModel | output = [] }
            in
            ( updateTerminalSessionsData model.focussedTerminalID (\_ -> clearedSessionModel) model, Cmd.none )

        CreateSession ->
            let
                -- list from string
                createArgs =
                    String.split " " model.activeTextInput

                title =
                    Maybe.withDefault ("session" ++ String.fromInt model.terminalCount) (Array.get 1 (fromList createArgs))
            in
            ( createNewSession title
                { model
                    | terminalCount = model.terminalCount + 1
                    , focussedTerminalID = title
                    , terminalSessionsData =
                        Dict.insert title
                            { initialSessionData | sessionId = title }
                            model.terminalSessionsData
                }
            , Cmd.none
            )

        FocusSession id_ ->
            ( { model | focussedTerminalID = id_ }, Cmd.none )



-- VIEW


getActiveSessionData : Model -> TerminalSessionData
getActiveSessionData { focussedTerminalID, terminalSessionsData } =
    Dict.get focussedTerminalID terminalSessionsData
        |> Maybe.withDefault initialSessionData


generateTerminalSessionList : List TerminalSessionData -> List (Html Msg)
generateTerminalSessionList terminalSessionsData =
    List.map
        (\terminalSessionData ->
            span
                [ onClick (FocusSession terminalSessionData.sessionId)
                , class "nav-menu__item"
                ]
                [ span [] [ text terminalSessionData.sessionId ] ]
        )
        terminalSessionsData


view : Model -> Document Msg
view model =
    { title = model.title
    , body =
        [ pre
            [ id "app" ]
            [ header [ class "header__container" ]
                [ div [ class "title-bar__container" ]
                    [ h2 [ class "title-bar__heading" ] [ text "jvterm" ]
                    , nav [ class "nav-menu__container" ]
                        [ div [ class "nav-menu__list" ]
                            (generateTerminalSessionList (Dict.values model.terminalSessionsData))
                        ]
                    ]
                ]
            , main_ []
                [ section [ class "cli-session__container" ]
                    [ generateCliSessionView
                        model.activeTextInput
                        (getActiveSessionData model)
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
