module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, textarea, input)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onInput)

---- MODEL ----


type alias Model =
    { text : String
    , results: Maybe (List String) }


init : ( Model, Cmd Msg )
init =
    ( { text = ""
        , results = Nothing
      }, Cmd.none )



---- UPDATE ----


type Msg
    = TextChange String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        TextChange text ->
            ( { model | text = text }, Cmd.none )




---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Miks – Create random mixes of people" ]
         , textarea [ value model.text, onInput TextChange ][]
         , div [][ input [ type_ "submit", value "Submit" ][]]
         , viewResults model.results
        ]

viewResults: Maybe (List String) -> Html msg
viewResults results =
    case results of
        Just(list) -> div [] [text "result"]
        _ -> div [] [text "nada"]

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
