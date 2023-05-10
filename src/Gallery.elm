module Gallery exposing (..)

import Image exposing ( image, updateImage)
import Image exposing ( ImageModel, Msg )


-- MAIN
--
--
imageModel : ImageModel
imageModel =
    { src = "./image.jpg"
    , alt = "image-description"
    , class = "image__thumb"
    , caption = "an image caption"
    }

--
--
-- MODEl
--
galleryModel : List ImageModel
galleryModel =
    { src = "./image.jpg"
    , alt = "image-description"
    , class = "image__thumb"
    , caption = "an image caption"
    }
--


GalleryInit : ( GalleryModel -> Cmd Msg )


-- UPDATE
--
--
update
--
--
-- VIEW
--
--
--
--
--
