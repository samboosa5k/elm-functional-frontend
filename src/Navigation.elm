module Navigation exposing (navLinks, viewer)

import Html exposing (Html, a, header, li, nav, text, ul)
import Html.Attributes exposing (class)
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
    a [ Route.routeHref navLink.page ] [ text navLink.label ]


navigationLinks : List NavLink -> Html msg
navigationLinks linkList =
    nav [ class "nav-menu__container" ]
        [ ul [ class "nav-menu__list" ]
            (List.map
                (\x -> li [ class "nav-menu__item" ] [ link x ])
                linkList
            )
        ]


viewer : List NavLink -> Html msg
viewer linkList =
    header [ class "header__container" ] [ navigationLinks linkList ]
