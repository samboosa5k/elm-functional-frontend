module Internal.Index exposing (..)

import Dict exposing (Dict)


type alias Index =
    String


type alias Indexed =
    Dict Index (List Index)
