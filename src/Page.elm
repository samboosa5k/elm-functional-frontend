module Page exposing (viewer)

import Html exposing (Html, div, text)
import Route exposing (Route)


viewer : Route -> Html msg
viewer route =
    case route of
        Route.Home ->
            div [] [ text "I am home" ]

        Route.About ->
            div [] [ text "About me page" ]

        _ ->
            div [] [ text "This page is not found" ]
