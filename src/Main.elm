module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, h1, h2, li, p, text, ul)
import Html.Attributes exposing (href)
import Page
import Route exposing (Route)
import Switch exposing (init)
import Url



--  MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Route
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url Route.Root, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model
                | url = url
                , route = Maybe.withDefault model.route (Route.fromUrl url)
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ text "The current URL is: "
        , p [] [ text (Url.toString model.url) ]
        , ul []
            [ viewLink Route.Home "Home"
            , viewLink Route.About "About"
            , viewLink Route.NotFound "404"
            ]
        , h2
            []
            [ text "The resolved route: " ]
        , p [] [ text (Route.routeToString model.route) ]
        , h1 [] [ text "The content:" ]
        , Page.viewer model.route
        ]
    }


viewLink : Route -> String -> Html msg
viewLink route label =
    li [] [ a [ Route.routeHref route ] [ text label ] ]
