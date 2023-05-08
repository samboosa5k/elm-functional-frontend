module Switch exposing (..)

import Browser
import Html exposing (Html, button, div, label, text)
import Html.Events exposing (onClick)



-- MAIN


main : Program () Model Bool
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { enabled : Bool
    }


init : Model
init =
    { enabled = False
    }



-- UPDATE


update : Bool -> Model -> Model
update bool model =
    case bool of
        False ->
            { model | enabled = True }

        True ->
            { model | enabled = False }


stringFromBool : Bool -> String
stringFromBool bool =
    if bool then
        "True"

    else
        "False"



-- VIEW


view : Model -> Html Bool
view model =
    div []
        [ label [] [ text "Switch label: " ]
        , button [ onClick model.enabled ] [ text "Switch" ]
        , div [] [ text (stringFromBool model.enabled) ]
        ]
