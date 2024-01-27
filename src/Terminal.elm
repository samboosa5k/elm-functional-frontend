module Terminal exposing (Command, Model, Msg, commandParser, init, initNew, update, view)

import Html exposing (Attribute, Html, div, h2, header, input, p, section, text)
import Html.Attributes exposing (class, id, placeholder, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json
import Parser exposing (..)


type Command
    = ClearSession
    | CreateSession
    | Nothing


commandParser : Parser Command
commandParser =
    oneOf
        [ Parser.map (\_ -> ClearSession) (keyword "clear")
        , Parser.map (\_ -> CreateSession) (keyword "new")
        ]



-- MODEL


type alias Model =
    { id_ : Int
    , currentInput : String
    , evaluate : Bool
    , outputResponse : String
    }


init : Model
init =
    { id_ = 0
    , currentInput = "first terminal"
    , evaluate = False
    , outputResponse = ""
    }


initNew : Int -> Model
initNew i =
    { init | id_ = i, currentInput = "New terminal entry field" ++ String.fromInt i }



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
            ( { inputModel | currentInput = inputContent }, Cmd.none )

        HandleEnter ->
            ( { inputModel | evaluate = True }, Cmd.none )

        -- let
        --     parsedCommandResult =
        --         Parser.run commandParser inputModel.currentInput
        -- in
        -- case parsedCommandResult of
        --     Ok ClearSession ->
        --         let
        --             newModel =
        --                 initNew inputModel.id_
        --         in
        --         ( { newModel | outputResponse = "Session cleared" }, Cmd.none )
        --     -- Logic for creating sessions should be moved up to Main
        --     Ok CreateSession ->
        --         ( { inputModel
        --             | currentInput = ""
        --             , parsedCommand = CreateSession
        --             , outputResponse =
        --                 inputModel.outputResponse
        --                     ++ "\n"
        --                     ++ inputModel.currentInput
        --                     ++ "\n"
        --                     ++ "new session created"
        --           }
        --         , Cmd.none
        --         )
        --     Ok Nothing ->
        --         ( inputModel, Cmd.none )
        --     Err _ ->
        --         ( { inputModel
        --             | currentInput = ""
        --             , parsedCommand = Nothing
        --             , outputResponse =
        --                 inputModel.outputResponse
        --                     ++ "\n"
        --                     ++ inputModel.currentInput
        --           }
        --         , Cmd.none
        --         )
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



-- Either all command parsing is done in main, or  we map the parser + update function to a parameter
-- e.g. handleParsedCommand


inputField { id_, currentInput } handleInput handleKeyDown =
    input
        [ id (String.fromInt id_)
        , class "terminal-input__field"
        , placeholder "Please enter a command"
        , value currentInput
        , onInput handleInput
        , onKeyDown handleKeyDown
        ]
        []


view : List Model -> (Int -> Msg -> msg) -> List (Html msg)
view terminalSessions updateBySessionID =
    if List.length terminalSessions > 0 then
        List.map
            (\session ->
                Html.map (updateBySessionID session.id_)
                    (section []
                        [ header [ class "header__container" ]
                            [ div [ class "title-bar__container" ]
                                [ h2 [ class "title-bar__heading" ] [ text "jvterm" ]
                                ]
                            ]
                        , div [ class "cli-session__container" ]
                            [ div [ class "cli-session__block" ]
                                [ p [ class "cli-session__block" ] [ text session.outputResponse ] ]
                            , div [ class "cli-session__block" ]
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
