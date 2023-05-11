module Main exposing (Model, init)

import Image



-- MAIN
-- MODEL


type alias Model =
    { imageFocus : Image.Model
    , galleryData : List Image.Model
    }
