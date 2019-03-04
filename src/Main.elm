module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, h1, input, li, text, textarea, ul)
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
    , persons : List String
    , teamCount : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { text = placeholderContent
      , persons = []
      , teamCount = 2
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = TextChange String
    | TeamCountChange String
    | Submit
    | Shuffled (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TextChange text ->
            ( { model | text = text }, Cmd.none )

        TeamCountChange str ->
            case String.toInt str of
                Just int ->
                    ( { model | teamCount = int }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Submit ->
            ( model
            , Random.generate Shuffled (shuffleNames model.text)
            )

        Shuffled persons ->
            ( { model | persons = persons }, Cmd.none )


shuffleNames : String -> Random.Generator (List String)
shuffleNames text =
    text
        |> String.trim
        |> String.split ","
        |> Random.List.shuffle



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Miks –\u{00A0}Create random teams of a group of people" ]
        , textarea [ value model.text, onInput TextChange, placeholder placeholderContent ] []
        , div [] [ input [ type_ "number", value (String.fromInt model.teamCount), onInput TeamCountChange ] [] ]
        , div [] [ input [ type_ "submit", value "Shuffle!", onClick Submit ] [] ]
        , div [] (List.map viewTeam <| split (List.length model.persons // model.teamCount) model.persons)
        ]


split : Int -> List a -> List (List a)
split i list =
    case List.take i list of
        [] ->
            []

        listHead ->
            listHead :: split i (List.drop i list)


viewTeam : List String -> Html msg
viewTeam team =
    ul [] (List.map viewTeamMember team)


viewTeamMember : String -> Html msg
viewTeamMember person =
    li [] [ text person ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
