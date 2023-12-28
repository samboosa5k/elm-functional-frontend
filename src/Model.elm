module Model exposing (..)

import Browser
import Browser.Navigation as Nav
import Route exposing (Route)
import String exposing (String)
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ToggleTyping
    | Change String
    | KeyDown Int


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Route
    , typingActive : Bool
    , command : String
    , input : List String
    }
