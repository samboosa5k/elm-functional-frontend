module ItemList exposing (..)

import Html exposing (Html, div, img, li, section, text, ul)
import Html.Attributes exposing (alt, class, src)



-- MAIN
-- MODEL


type alias ImageArg =
    { src : String, alt : String, class : String, caption : String }


initImageArg : ImageArg -> ImageArg
initImageArg model =
    { src = model.src
    , alt = model.alt
    , class = model.class
    , caption = model.caption
    }


type alias BaseArg =
    { text : String }


type ListItemMsg
    = DIV String
    | IMG ImageArg


update : ListItemMsg -> Html msg
update msg =
    case msg of
        DIV model ->
            li []
                [ div [] [ text model ]
                ]

        IMG model ->
            li []
                [ img [ src model.src, alt model.alt, class model.class ] []
                ]



-- INIT


type alias Model =
    List ListItemMsg


initialList : Model
initialList =
    [ DIV "test"
    , IMG
        { src = "./image.jpg"
        , alt = "image-description"
        , class = "image__thumb"
        , caption = "1st image caption"
        }
    , DIV "Some other string"
    ]



-- VIEW


view : Model -> Html Model
view model =
    ul []
        (List.map update model)


main : Html Model
main =
    section []
        [ view initialList
        ]
