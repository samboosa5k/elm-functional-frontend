module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, section, text)
import Html.Events exposing (onClick)
import ItemList exposing (..)



-- MODEL


type alias TitleModel =
    { text : String
    }



-- VIEW


title : TitleModel -> Html msg
title titleModel =
    h1 [] [ text titleModel.text ]



-- MODEL


type alias Model =
    { titleComponent : TitleModel
    , listItems : ItemList.Model
    }


init : Model
init =
    { titleComponent =
        { text = "Default Title" }
    , listItems = []
    }



-- UPDATE


type ShowMsg
    = Show
    | Hide


update : ShowMsg -> Model -> Model
update showMsg model =
    case showMsg of
        Hide ->
            { model
                | titleComponent = init.titleComponent
                , listItems = init.listItems
            }

        Show ->
            { model
                | titleComponent = { text = "Data list" }
                , listItems = ItemList.initialList
            }



-- VIEW


view : Model -> Html ShowMsg
view model =
    section []
        [ div []
            [ button [ onClick Show ] [ text "SHOW" ]
            , button [ onClick Hide ] [ text "HIDE" ]
            ]
        , div []
            [ title model.titleComponent
            ]
        , div []
            (List.map ItemList.update model.listItems)
        ]



-- MAIN


main : Program () Model ShowMsg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
