module Main exposing (main)

import Browser exposing (Document)
import Html exposing (header, input, main_, pre, section, text)
import Html.Attributes exposing (class, id, placeholder, value)
import Html.Events exposing (onInput)
import Platform.Cmd as Cmd
import Terminal


type alias Model =
    { userInput : String
    , terminalOutput : List { inputCommand : String, outputResponse : String }
    }


initialState : Model
initialState =
    { userInput = ""
    , terminalOutput = [ { inputCommand = "", outputResponse = "" } ]
    }


type Msg
    = NoOp
    | HandleUserInput String
    | HandleEnter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        HandleUserInput s ->
            ( { model | userInput = s }, Cmd.none )

        HandleEnter ->
            ( model, Cmd.none )


view : Model -> Document Msg
view { userInput } =
    { title =
        "~/jvterm"
    , body =
        [ pre
            [ id "app" ]
            [ header [] []
            , main_ [ class "main-content__container" ]
                [ section [ class "main-content__block" ] [ text "Content block 1" ]
                , section [ class "main-content__block" ]
                    [ input
                        [ id "terminal__input"
                        , placeholder "please enter a command"
                        , value userInput
                        , onInput HandleUserInput
                        ]
                        []
                    , Terminal.view { userInput = userInput } HandleUserInput
                    ]
                ]
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> ( initialState, Cmd.none )
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
