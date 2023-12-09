module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, section, text)
import Html.Events exposing (onClick)



-- VIEW


type alias TitleModel =
    { text : String
    }


titleInit : TitleModel
titleInit =
    { text = "This is the title"
    }


title : TitleModel -> Html msg
title titleModel =
    h1 [] [ text titleModel.text ]



-- MODEL


type alias ContentModel =
    { text : String
    }


contentInit : ContentModel
contentInit =
    { text = "Nested app text"
    }



-- VIEW


content : ContentModel -> Html msg
content contentModel =
    div []
        [ div [] [ text contentModel.text ]
        ]



-- MODEL


type ShowMsg
    = Show
    | Hide



-- type ShowMsgHtml
--     = Int


getContent : Int -> Html msg
getContent a =
    case a of
        0 ->
            content contentInit

        1 ->
            title titleInit

        _ ->
            title titleInit


type alias Model =
    { activeComponent : Int
    }


init : Model
init =
    { activeComponent = 0 }


update : ShowMsg -> Model -> Model
update showMsg model =
    case showMsg of
        Show ->
            { model | activeComponent = 0 }

        Hide ->
            { model | activeComponent = 1 }


view : Model -> Html ShowMsg
view model =
    section []
        [ div []
            [ button [ onClick Show ] [ text "SHOW" ]
            , button [ onClick Hide ] [ text "HIDE" ]
            ]
        , div []
            [ title titleInit
            , content contentInit
            ]
        , div []
            [ getContent model.activeComponent ]
        ]


main : Program () Model ShowMsg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
