module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, header, li, main_, nav, section, text, ul)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { title : String
    }


homePageData : Model
homePageData =
    { title = "Home"
    }


aboutPageData : Model
aboutPageData =
    { title = "About"
    }



-- UPDATE


type ViewMsg
    = Home
    | About


type Msg
    = SetViewState ViewMsg


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetViewState Home ->
            { model | title = homePageData.title }

        SetViewState About ->
            { model | title = aboutPageData.title }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header []
            [ nav []
                [ ul []
                    [ li [ onClick (SetViewState Home) ] [ text "Home" ]
                    , li [ onClick (SetViewState About) ] [ text "About" ]
                    , li [] [ text "Contact" ]
                    ]
                ]
            ]
        , main_ []
            [ section []
                [ div []
                    [ h1 [] [ text "Section ++  H1 -> Heading ", text model.title ]
                    , div [] [ text "Section -> Div -> Text" ]
                    ]
                ]
            ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = { title = "Hello World" }
        , update = update
        , view = view
        }
