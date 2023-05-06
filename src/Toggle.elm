module Toggle exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { button1 : Bool
    , button2 : Bool
    , button3 : Bool
    }


init : Model
init =
    { button1 = False
    , button2 = False
    , button3 = False
    }



-- UPDATE


type Msg
    = Button1 | Button2 | Button3


update : Msg -> Model -> Model
update msg model =
    case msg of
        Button1 ->
            { model | button1 = True }

        Button2 ->
            { model | button2 = True }

        Button3 ->
            { model | button3 = True }

stringFromBool : Bool -> String 
stringFromBool bool =
    if bool then
        "True"
    
    else
        "False"

-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Button1 ] [ text "Button 1", text ( stringFromBool model.button1 ) ]
        , button [ onClick Button2 ] [ text "Button 2", text ( stringFromBool model.button2 ) ]
        , button [ onClick Button3 ] [ text "Button 3", text ( stringFromBool model.button3 ) ]
        ]
