module Input exposing (Model, Msg, multiInput, update)

import Html exposing (Attribute, Html, div, input)
import Html.Attributes exposing (class, id, placeholder, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json



-- MODEL


type alias Model =
    { id_ : Int, content : String, outputResponse : String }



-- REFERENCE: https://blog.revathskumar.com/2018/05/elm-message-passing-between-modules.html
-- ARTICLE AUTHOR: https://github.com/revathskumar
-- UPDATE


type Msg
    = HandleWindowInput String
    | HandleWindowKeydown Int
    | HandleWindowEnter


update : Msg -> Model -> ( Model, Cmd Msg )
update windowMsg inputModel =
    case windowMsg of
        HandleWindowInput inputContent ->
            ( { inputModel | content = inputContent }, Cmd.none )

        HandleWindowEnter ->
            ( { inputModel | content = "", outputResponse = inputModel.content }, Cmd.none )

        HandleWindowKeydown keyCode ->
            if keyCode == 13 then
                update HandleWindowEnter inputModel

            else
                ( inputModel, Cmd.none )



-- VIEW


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


multiInputField : Model -> (String -> msg) -> (Int -> msg) -> Html msg
multiInputField { id_, content } handleInput handleKeyDown =
    input
        [ id (String.fromInt id_)
        , class "terminal-input__field"
        , placeholder "Please enter a command"
        , value content
        , onInput handleInput
        , onKeyDown handleKeyDown
        ]
        []


multiInput : List Model -> (Int -> Msg -> msg) -> Html msg
multiInput listInputs updateByIndex =
    div [ class "terminal-input" ]
        (if List.length listInputs > 0 then
            List.map
                (\listInput ->
                    Html.map (updateByIndex listInput.id_)
                        (multiInputField listInput HandleWindowInput HandleWindowKeydown)
                )
                listInputs

         else
            [ input [ id "first-input", class "terminal-input__field", placeholder "Please enter a command", value "" ] [] ]
        )
