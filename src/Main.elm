module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, h1, h2, header, li, main_, nav, section, text, ul)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Switch exposing (init)
import Url
import Url.Parser exposing (Parser, map, oneOf, s)



-- ROUTES
-- MODEL


type View
    = Home
    | About
    | NotFound


type ViewMsg
    = SetViewState View



-- ROUTE PARSING
-- MODEL


type Route
    = View String


routeParser : Parser (View -> a) a
routeParser =
    oneOf
        [ map Home (s "/")
        , map Home (s "home")
        , map About (s "about")
        ]



-- MODEL


type alias ViewModel =
    { title : String
    }


homePageData : ViewModel
homePageData =
    { title = "Home"
    }


aboutPageData : ViewModel
aboutPageData =
    { title = "About"
    }


notFoundPageData : ViewModel
notFoundPageData =
    { title = "Not Found"
    }



-- UPDATE


routeUpdate : String -> ViewMsg
routeUpdate parsedUrl =
    case parsedUrl of
        "home" ->
            SetViewState Home

        "about" ->
            SetViewState About

        _ ->
            SetViewState NotFound


viewUpdate : ViewMsg -> ViewModel -> ViewModel
viewUpdate msg model =
    case msg of
        SetViewState Home ->
            { model | title = homePageData.title }

        SetViewState About ->
            { model | title = aboutPageData.title }

        SetViewState NotFound ->
            { model | title = notFoundPageData.title }



-- VIEW


viewContent : ViewModel -> Html ViewMsg
viewContent model =
    div []
        [ header []
            [ nav []
                [ ul []
                    [ li [ onClick (routeUpdate "home") ] [ text "Home" ]
                    , li [ onClick (routeUpdate "about") ] [ text "About" ]
                    , li [] [ text "Contact" ]
                    ]
                ]
            ]

        -- , nav []
        --     [ ul []
        --         [ a [ href "/" ] [ text "Home" ]
        --         , a [ href "about" ] [ text "About" ]
        --         ]
        --     ]
        , main_ []
            [ section []
                [ div []
                    [ h1 [] [ text "Section ++  H1 -> Heading ", text model.title ]
                    , div [] [ text "Section -> Div -> Text" ]
                    ]
                ]
            ]
        ]



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
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url, Cmd.none )



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
            ( { model | url = url }
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
        , h2 [] [ text (Url.toString model.url) ]
        , ul []
            [ viewLink "/home"
            , viewLink "/about"
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
