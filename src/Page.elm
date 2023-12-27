module Page exposing (..)

import Html exposing (Attribute, Html, div, input, main_, p, section, text)
import Html.Attributes exposing (class, id, placeholder, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json
import Model exposing (Model, Msg(..))
import Route
import Url



-- ELEMENT


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


terminalOutput : Model -> Html msg
terminalOutput { input } =
    div []
        (List.map
            (\x -> p [] [ text x ])
            input
        )


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)



-- REFERENCE: https://stackoverflow.com/questions/40113213/how-to-handle-enter-key-press-in-input-field


terminalInput : Model -> Html Msg
terminalInput model =
    input [ id "terminal__input", placeholder "Input command...", value model.command, onInput Change, onKeyDown KeyDown ] []


viewer : Model -> Html Msg
viewer model =
    main_ [ class "main-content__container" ]
        [ section [ class "main-content__block" ] [ viewContent model ]
        , section [ class "main-content__block" ]
            [ p [] [ text "The current URL is: " ]
            , p [] [ text (Url.toString model.url) ]
            , text "The resolved route is: "
            , p [] [ text (Route.routeToString model.route) ]
            ]
        , section [ class "main-content__block" ] [ terminalInput model ]
        , section [ class "main-content__block" ] [ terminalOutput model ]
        ]
