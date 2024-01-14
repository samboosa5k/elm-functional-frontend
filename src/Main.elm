module Main exposing (main)

import Array exposing (fromList, push, toList)
import Browser exposing (Document)
import Html exposing (div, header, main_, pre)
import Html.Attributes exposing (class, id)
import Html.Events exposing (keyCode)
import Input
import List.Extra
import Platform.Cmd as Cmd exposing (Cmd)
import Terminal


type alias Model =
    { userInput : String
    , terminalOutput : List { inputCommand : String, outputResponse : String }
    , inputWindows : List Input.Model
    }


initialState : Model
initialState =
    { userInput = ""
    , terminalOutput = [ { inputCommand = "", outputResponse = "" } ]
    , inputWindows =
        [ { id_ = 0
          , content = "first terminal"
          , outputResponse = ""
          }
        , { id_ = 1
          , content = "second terminal"
          , outputResponse = ""
          }
        ]
    }


type Msg
    = NoOp
    | HandleUserInput String
    | HandleKeydown Int
    | HandleEnter
    | UpdateWindow Int Input.Msg


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

        UpdateWindow indexId windowMsg ->
            -- REFERENCE: https://blog.revathskumar.com/2018/05/elm-message-passing-between-modules.html
            -- ARTICLE AUTHOR: https://github.com/revathskumar
            let
                maybeIndex =
                    List.Extra.findIndex (\windowData -> windowData.id_ == indexId) model.inputWindows

                index =
                    case maybeIndex of
                        Just indexNr ->
                            indexNr

                        Nothing ->
                            -1

                selectedInput =
                    case List.Extra.getAt index model.inputWindows of
                        Just windowInput ->
                            windowInput

                        Nothing ->
                            { id_ = 0, content = "", outputResponse = "" }

                ( updatedInput, cmdMsg ) =
                    Input.update windowMsg selectedInput

                inputs =
                    List.Extra.setAt index updatedInput model.inputWindows
            in
            ( { model | inputWindows = inputs }, Cmd.map (UpdateWindow indexId) cmdMsg )


view : Model -> Document Msg
view { userInput, terminalOutput, inputWindows } =
    { title =
        "~/jvterm"
    , body =
        [ pre
            [ id "app" ]
            [ header [ class "header__container" ]
                [ Terminal.titleView "/user/jasper/home"
                ]
            , main_ [ class "main-content__container" ]
                [ div
                    []
                    (Terminal.outputView
                        terminalOutput
                    )
                , div
                    [ class "main-content__block" ]
                    [ Terminal.inputView
                        { userInput = userInput }
                        HandleUserInput
                        HandleKeydown
                    ]
                , div [ class "main-content__block" ] [ Input.multiInput inputWindows UpdateWindow ]
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
