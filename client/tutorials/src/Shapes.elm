module Shapes exposing (main)

import Html
    exposing
        ( Html
        , beginnerProgram
        , div
        , input
        , label
        , text
        , span
        )
import Html.Attributes exposing (type_, name, checked, value, id, class)


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
    div [ id "shapes-app" ]
        [ div []
            [ label [ class "container" ] [ text "Square", input [ type_ "radio", name "shapes", checked True ] [], span [ class "checkmark" ] [] ]
            , label [ class "container" ] [ text "Rectangle", input [ type_ "radio", name "shapes" ] [], span [ class "checkmark" ] [] ]
            ]
        , div []
            [ label [] [ text "Side Length: " ]
            , input [ type_ "number", value "4" ] []
            ]
        , div []
            [ span [] [ text "Area: 16" ]
            ]
        ]
