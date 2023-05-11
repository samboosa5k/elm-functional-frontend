module Gallery exposing (..)

import Browser
import Html exposing (Html, div)
import Image exposing (image)



-- MAIN


main =
    Browser.sandbox { init = initialModel, update = update, view = view }



-- MODEL


type alias GalleryModel =
    { images : List Image.Model }


initialModel : GalleryModel
initialModel =
    { images =
        [ { src = "./image.jpg"
          , alt = "image-description"
          , class = "image__thumb"
          , caption = "1st image caption"
          }
        , { src = "./image.jpg"
          , alt = "image-description"
          , class = "image__thumb"
          , caption = "another caption"
          }
        ]
    }



-- UPDATE
-- The purpose of this update is just to satisfy the browser.sandbox type
-- signature. There is no actual updating.


update msg model =
    case msg of
        _ ->
            model



-- VIEW


view : GalleryModel -> Html Image.Model
view model =
    div []
        (List.map image model.images)



--
