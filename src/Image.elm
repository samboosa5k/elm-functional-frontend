module Image exposing (..)

import Browser
import Html exposing (Html, div, figcaption, figure, img, text)
import Html.Attributes exposing (alt, class, src)



-- MAIN
--
--
--main =
--    Browser.sandbox { init = init, update = update, view = view }
-- MODEL


type alias ImageModel =
    { src : String
    , alt : String
    , class : String
    , caption : String
    }


imageModel : ImageModel
imageModel =
    { src = "./image.jpg"
    , alt = "image-description"
    , class = "image__thumb"
    , caption = "an image caption"
    }



--gallery : List Model
--gallery =
--    [ init
--    , init
--    , init
--    , init
--    ]
-- UPDATE


type Msg
    = Change ImageModel


updateImage : Msg -> ImageModel -> ImageModel
updateImage msg imageCfg =
    case msg of
        Change newImageModel ->
            { imageCfg
                | src = newImageModel.src
                , alt = newImageModel.alt
                , class = newImageModel.class
                , caption = newImageModel.caption
            }



--galleryUpdate : Msg -> List (Model -> Html Msg)
-- VIEW


image : ImageModel -> Html Msg
image imageModel =
    div []
        [ figure [] []
        , img [ src imageModel.src, alt imageModel.alt, class imageModel.class ] []
        , figcaption [] [ text imageModel.caption ]
        ]
