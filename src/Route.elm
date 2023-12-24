module Route exposing (Model, Route(..), fromUrl, replaceUrl, routeHref, routeParser, routeToString)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)



-- Example @ https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm
--
--
-- ROUTING


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Route
    }


type Route
    = Root
    | Home
    | About
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Home (s "home")
        , Parser.map About (s "about")
        , Parser.map NotFound (s "404")
        ]



-- INTERNAL


routeToPieces : Route -> List String
routeToPieces route =
    case route of
        Root ->
            []

        Home ->
            [ "home" ]

        About ->
            [ "about" ]

        NotFound ->
            [ "404" ]


routeToString : Route -> String
routeToString route =
    "#/" ++ String.join "/" (routeToPieces route)



-- PUBLIC HELPERS


routeHref : Route -> Attribute msg
routeHref route =
    Attr.href (routeToString route)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse routeParser
