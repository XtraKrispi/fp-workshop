module Intro exposing (main)

import Html exposing (Html, button, span, div, text)
import Html.Attributes exposing (id)


main : Html msg
main =
    div [ id "intro-app" ]
        [ button [] [ text "-" ]
        , span [] [ text "0" ]
        , button [] [ text "+" ]
        ]
