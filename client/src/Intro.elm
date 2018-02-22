module Intro exposing (main)

import Html exposing (Html, beginnerProgram, button, span, div, text)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)


type alias Model =
    Int


type Msg
    = Increment
    | Decrement
    | Reset


main : Program Never Model Msg
main =
    beginnerProgram
        { model = 0
        , view = view
        , update = update
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            if model == 0 then
                0
            else
                model - 1

        Reset ->
            0


view : Model -> Html Msg
view model =
    div [ id "intro-app" ]
        [ button [ onClick Decrement ] [ text "-" ]
        , span [] [ text (toString model) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Reset ] [ text "Reset" ]
        ]
