module Page exposing (..)

import Html exposing (Html, div, text)
import Route exposing (Route)


page : Route -> Html msg
page route =
    case route of
        Route.Home ->
            div [] [ text "I am home" ]

        Route.About ->
            div [] [ text "About me page" ]

        Route.NotFound ->
            div [] [ text "This page is not found" ]
