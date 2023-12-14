module Element.Title exposing (..)

import Html exposing (Html, h1, text)



-- MODEL


type alias Model =
    { text : String
    }



-- VIEW


type alias View msg =
    Model -> Html msg


title : Model -> Html msg
title model =
    h1 [] [ text model.text ]
