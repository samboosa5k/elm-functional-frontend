module Terminal exposing (inputView, outputView, titleView)

import Html exposing (Attribute, Html, div, h1, input, p, text)
import Html.Attributes exposing (class, id, placeholder, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json


type alias OutputLine =
    { inputCommand : String
    , outputResponse : String
    }


outputView : List OutputLine -> List (Html msg)
outputView model =
    List.map
        (\x -> div [ class "main-content__block" ] [ text "jvterm >", p [] [ text x.inputCommand ], p [] [ text x.outputResponse ] ])
        model


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


inputView : { a | userInput : String } -> (String -> msg) -> (Int -> msg) -> Html msg
inputView { userInput } handleUserInput handleKeyDown =
    div [ class "terminal-input" ]
        [ text "jvterm > "
        , input
            [ class "terminal-input__field"
            , placeholder "please enter a command"
            , value userInput
            , onInput handleUserInput
            , onKeyDown handleKeyDown
            ]
            []
        ]


titleView : String -> Html msg
titleView titleText =
    div [ class "title-bar__container" ]
        [ h1 [ class "title-bar__heading" ] [ text titleText ]
        ]
