module Model exposing (..)

import Browser
import Browser.Navigation as Nav
import Route exposing (Route)
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Change String
    | KeyDown Int
    | SubmitCommand


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Route
    , command : String
    , input : List String
    }
