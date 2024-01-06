module Terminal exposing (outputView, view)

import Html exposing (Attribute, Html, div, input, p, text)
import Html.Attributes exposing (id, placeholder, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json


type alias OutputLine =
    { inputCommand : String
    , outputResponse : String
    }


outputView : List OutputLine -> List (Html msg)
outputView model =
    List.map
        (\x -> div [] [ p [] [ text x.inputCommand ], p [] [ text x.outputResponse ] ])
        model


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


view : { a | userInput : String } -> (String -> msg) -> (Int -> msg) -> Html.Html msg
view { userInput } handleUserInput handleKeyDown =
    input
        [ id "terminal__input"
        , placeholder "please enter a command"
        , value userInput
        , onInput handleUserInput
        , onKeyDown handleKeyDown
        ]
        []
