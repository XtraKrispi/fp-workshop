module Shapes exposing (main)

import Html exposing (Html, beginnerProgram, div, input, label, text, span)
import Html.Attributes exposing (type_, name, checked, value)


type Msg
    = NoOp


type alias Model =
    {}


main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }


model : Model
model =
    {}


update : Msg -> Model -> Model
update _ model =
    model


view : Model -> Html Msg
view _ =
    div []
        [ div []
            [ label [] [ input [ type_ "radio", name "shapes", checked True ] [], text "Square" ]
            , label [] [ input [ type_ "radio", name "shapes" ] [], text "Rectangle" ]
            ]
        , div []
            [ label [] [ text "Side Length: " ]
            , input [ type_ "number", value "4" ] []
            ]
        , div []
            [ span [] [ text "Area: 16" ]
            ]
        ]
