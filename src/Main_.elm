module Main_ exposing (..)

import Array exposing (fromList, push, toList)
import Browser
import Browser.Navigation as Nav
import Html
import Html.Attributes exposing (href, id)
import Model exposing (Model, Msg(..))
import Navigation exposing (navLinks)
import Page
import Platform.Cmd as Cmd
import Route
import Url



--  MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = switchUpdater
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url Route.Root False "" [ "Initial command..." ], Cmd.none )



-- UPDATE


switchUpdater : Msg -> Model -> ( Model, Cmd Msg )
switchUpdater msg model =
    case msg of
        ToggleTyping ->
            if model.typingActive == True then
                ( { model | typingActive = False }, Cmd.none )

            else
                ( { model | typingActive = True }, Cmd.none )

        _ ->
            if model.typingActive == True then
                updateTerminal msg model

            else
                update msg model


updateTerminal : Msg -> Model -> ( Model, Cmd Msg )
updateTerminal msg model =
    case msg of
        Change newText ->
            ( { model | command = newText }, Cmd.none )

        KeyDown keyCode ->
            if keyCode == 13 then
                ( { model | command = "", input = toList (push model.command (fromList model.input)) }, Cmd.none )

            else
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


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

        _ ->
            ( model, Cmd.none )



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