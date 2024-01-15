module Main exposing (main)

import Browser exposing (Document)
import Html exposing (main_, pre)
import Html.Attributes exposing (id)
import List.Extra
import Platform.Cmd as Cmd exposing (Cmd)
import Terminal


type alias Model =
    { terminalSessions : List Terminal.Model
    }


initialState : Model
initialState =
    { terminalSessions =
        [ { id_ = 0
          , content = "first terminal"
          , outputResponse = ""
          }
        , Terminal.initNew 1
        , Terminal.initNew 2
        , Terminal.initNew 3
        ]
    }


type Msg
    = NoOp
    | UpdateSession Int Terminal.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateSession indexId sessionMsg ->
            -- REFERENCE: https://blog.revathskumar.com/2018/05/elm-message-passing-between-modules.html
            -- ARTICLE AUTHOR: https://github.com/revathskumar
            let
                maybeIndex =
                    List.Extra.findIndex (\sessionData -> sessionData.id_ == indexId) model.terminalSessions

                index =
                    case maybeIndex of
                        Just indexNr ->
                            indexNr

                        Nothing ->
                            -1

                selectedInput =
                    case List.Extra.getAt index model.terminalSessions of
                        Just sessionInput ->
                            sessionInput

                        Nothing ->
                            Terminal.initNew 0

                ( updatedInput, cmdMsg ) =
                    Terminal.update sessionMsg selectedInput

                inputs =
                    List.Extra.setAt index updatedInput model.terminalSessions
            in
            ( { model | terminalSessions = inputs }, Cmd.map (UpdateSession indexId) cmdMsg )


view : Model -> Document Msg
view { terminalSessions } =
    { title =
        "~/jvterm"
    , body =
        [ pre
            [ id "app" ]
            [ main_ []
                (Terminal.view terminalSessions UpdateSession)
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
