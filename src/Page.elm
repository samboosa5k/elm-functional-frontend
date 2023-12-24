module Page exposing (..)

import Html exposing (Html, div, main_, p, section, text)
import Html.Attributes exposing (class)
import Route exposing (Model)
import Url


viewContent : Model -> Html msg
viewContent model =
    case model.route of
        Route.Root ->
            div [] [ text "I am at /" ]

        Route.Home ->
            div [] [ text "I am home" ]

        Route.About ->
            div [] [ text "About me page" ]

        _ ->
            div [] [ text "This page is not found" ]


viewer : Model -> Html msg
viewer model =
    main_ [ class "main-content__container" ]
        [ section [ class "main-content__block" ] [ viewContent model ]
        , section [ class "main-content__block" ]
            [ p [] [ text "The current URL is: " ]
            , p [] [ text (Url.toString model.url) ]
            , text "The resolved route is: "
            , p [] [ text (Route.routeToString model.route) ]
            ]
        ]
