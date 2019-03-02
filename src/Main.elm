module Main exposing (Model, Msg(..), init, main, update, view, viewResults)

import Browser
import Html exposing (Html, div, h1, input, text, textarea)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Random
import Random.List
import Task exposing (Task)



---- CONSTANTS ----


placeholderContent =
    "John, Jane, Jack, Jill, Jason, James"



---- MODEL ----


type alias Model =
    { text : String
    , results : List String
    }


init : ( Model, Cmd Msg )
init =
    ( { text = placeholderContent
      , results = []
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = TextChange String
    | Submit
    | Results (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextChange text ->
            ( { model | text = text }, Cmd.none )

        Submit ->
            ( model
            , Random.generate Results (mapInputToResults model.text)
            )

        Results results ->
            ( { model | results = results }, Cmd.none )


mapInputToResults : String -> Random.Generator (List String)
mapInputToResults text =
    text
        |> String.split ","
        |> Random.List.shuffle



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Miks –\u{00A0}Create random teams of a group of people" ]
        , textarea [ value model.text, onInput TextChange, placeholder placeholderContent ] []
        , div [] [ input [ type_ "submit", value "Submit", onClick Submit ] [] ]
        , viewResults model.results
        ]


viewResults : List String -> Html msg
viewResults results =
    div []
        [ results
            |> List.map viewResult
            |> div []
        ]


viewResult : String -> Html msg
viewResult res =
    div [] [ text res ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
