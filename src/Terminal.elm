module Terminal exposing (Model, Msg, init, initNew, update, view)

import Html exposing (Attribute, Html, div, h2, header, input, p, section, text)
import Html.Attributes exposing (class, id, placeholder, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json



-- MODEL


type alias Model =
    { id_ : Int, content : String, outputResponse : String }


init : Model
init =
    { id_ = 0
    , content = "first terminal"
    , outputResponse = ""
    }


initNew : Int -> Model
initNew i =
    { init | id_ = i, content = "New terminal entry field" ++ String.fromInt i }



-- REFERENCE: https://blog.revathskumar.com/2018/05/elm-message-passing-between-modules.html
-- ARTICLE AUTHOR: https://github.com/revathskumar
-- UPDATE


type Msg
    = HandleInput String
    | HandleKeyCode Int
    | HandleEnter


update : Msg -> Model -> ( Model, Cmd Msg )
update sessionMsg inputModel =
    case sessionMsg of
        HandleInput inputContent ->
            ( { inputModel | content = inputContent }, Cmd.none )

        HandleEnter ->
            ( { inputModel | content = "", outputResponse = inputModel.content }, Cmd.none )

        HandleKeyCode keyCode ->
            if keyCode == 13 then
                update HandleEnter inputModel

            else
                ( inputModel, Cmd.none )



-- VIEW
-- REFERENCE: https://stackoverflow.com/questions/40113213/how-to-handle-enter-key-press-in-input-field


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


inputField : Model -> (String -> msg) -> (Int -> msg) -> Html msg
inputField { id_, content } handleInput handleKeyDown =
    input
        [ id (String.fromInt id_)
        , class "terminal-input__field"
        , placeholder "Please enter a command"
        , value content
        , onInput handleInput
        , onKeyDown handleKeyDown
        ]
        []


titleView : String -> Html msg
titleView titleText =
    div [ class "title-bar__container" ]
        [ h2 [ class "title-bar__heading" ] [ text titleText ]
        ]


output : Model -> Html msg
output { outputResponse } =
    div [ class "main-content__block" ]
        [ p [ class "main-content__block" ] [ text outputResponse ] ]


view : List Model -> (Int -> Msg -> msg) -> List (Html msg)
view terminalSessions updateByIndex =
    if List.length terminalSessions > 0 then
        List.map
            (\session ->
                Html.map (updateByIndex session.id_)
                    (section []
                        [ header [ class "header__container" ]
                            [ titleView "/usr/bin/jvterm" ]
                        , div [ class "main-content__container" ]
                            [ output session
                            , div [ class "main-content__block" ]
                                [ div [ class "terminal-input" ]
                                    [ inputField
                                        session
                                        HandleInput
                                        HandleKeyCode
                                    ]
                                ]
                            ]
                        ]
                    )
            )
            terminalSessions

    else
        [ div [ class "terminal-input" ]
            [ input
                [ id "first-input"
                , class "terminal-input__field"
                , placeholder "Please enter a command"
                , value ""
                ]
                []
            ]
        ]
