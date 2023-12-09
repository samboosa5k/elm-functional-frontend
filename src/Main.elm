module Main exposing (main)

import Html exposing (Html, div, h1, section, text)



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
    { title : String
    , text : String
    }


contentInit : ContentModel
contentInit =
    { title = "App Title"
    , text = "Nested app text"
    }



-- VIEW


content : ContentModel -> Html msg
content contentModel =
    div []
        [ div [] [ text contentModel.title ]
        , div [] [ text contentModel.text ]
        ]


main : Html msg
main =
    section []
        [ title titleInit
        , content contentInit
        ]
