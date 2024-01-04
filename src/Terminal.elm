module Terminal exposing (view)

import Html exposing (input)
import Html.Attributes exposing (id, placeholder, value)
import Html.Events exposing (onInput)


view : { a | userInput : String } -> (String -> msg) -> Html.Html msg
view { userInput } handleUserInput =
    input
        [ id "terminal__input"
        , placeholder "please enter a command"
        , value userInput
        , onInput handleUserInput
        ]
        []
