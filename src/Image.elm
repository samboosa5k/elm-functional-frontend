module Image exposing (Model, image)

import Html exposing (Html, div, figcaption, figure, img, text)
import Html.Attributes exposing (alt, class, src)



-- MODEL


type alias Model =
    { src : String
    , alt : String
    , class : String
    , caption : String
    }



-- VIEW


image : Model -> Html Model
image model =
    div []
        [ figure [] []
        , img [ src model.src, alt model.alt, class model.class ] []
        , figcaption [] [ text model.caption ]
        ]
