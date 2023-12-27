module Main exposing (..)

import Array exposing (fromList, push, toList)
import Browser
import Browser.Navigation as Nav
import Html
import Html.Attributes exposing (href, id)
import Model exposing (Model, Msg(..))
import Navigation exposing (navLinks)
import Page
import Route
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


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url Route.Root "" [ "Initial command..." ], Cmd.none )



-- UPDATE


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

        Change newContent ->
            ( { model | command = newContent }, Cmd.none )

        KeyDown key ->
            if key == 13 then
                ( { model | command = "", input = toList (push model.command (fromList model.input)) }, Cmd.none )

            else
                ( model, Cmd.none )

        SubmitCommand ->
            ( { model | command = "", input = toList (push model.command (fromList model.input)) }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Jasper's Elm App"
    , body =
        [ Html.pre [ id "app" ]
            [ Navigation.viewer navLinks
            , Page.viewer model
            ]
        ]
    }
