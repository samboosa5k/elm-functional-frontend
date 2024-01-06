module Main exposing (main)

import Array exposing (fromList, push, toList)
import Browser exposing (Document)
import Html exposing (header, main_, pre, section, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (keyCode)
import Platform.Cmd as Cmd exposing (Cmd)
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
    | HandleKeydown Int
    | HandleEnter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        HandleUserInput s ->
            ( { model | userInput = s }, Cmd.none )

        HandleEnter ->
            ( { model
                | userInput = ""
                , terminalOutput = toList (push { inputCommand = model.userInput, outputResponse = "" } (fromList model.terminalOutput))
              }
            , Cmd.none
            )

        HandleKeydown keyCode ->
            if keyCode == 13 then
                update HandleEnter model

            else
                update NoOp model


view : Model -> Document Msg
view { userInput, terminalOutput } =
    { title =
        "~/jvterm"
    , body =
        [ pre
            [ id "app" ]
            [ header [] []
            , main_ [ class "main-content__container" ]
                [ section [ class "main-content__block" ] [ text "Content block 1" ]
                , section [ class "main-content__block" ]
                    (Terminal.outputView
                        terminalOutput
                    )
                , section [ class "main-content__block" ]
                    [ Terminal.view
                        { userInput = userInput }
                        HandleUserInput
                        HandleKeydown
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
