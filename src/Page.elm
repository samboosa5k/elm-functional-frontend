module Page exposing (..)

import Html exposing (Html, a, div, header, li, main_, nav, text, ul)
import Route exposing (Route)


type alias NavLink =
    { page : Route
    , label : String
    }


navLinks : List NavLink
navLinks =
    [ { page = Route.Home
      , label = "Home"
      }
    , { page = Route.About
      , label = "About"
      }
    ]


link : NavLink -> Html msg
link navLink =
    li [] [ a [ Route.routeHref navLink.page ] [ text navLink.label ] ]


navBar : List NavLink -> Html msg
navBar linkList =
    nav []
        [ ul []
            (List.map
                link
                linkList
            )
        ]


viewHeader : List NavLink -> Html msg
viewHeader linkList =
    header []
        [ navBar linkList
        ]


viewContent : Route -> Html msg
viewContent route =
    case route of
        Route.Home ->
            div [] [ text "I am home" ]

        Route.About ->
            div [] [ text "About me page" ]

        _ ->
            div [] [ text "This page is not found" ]


viewer : Route -> Html msg
viewer route =
    div []
        [ viewHeader navLinks
        , main_ [] [ viewContent route ]
        ]
