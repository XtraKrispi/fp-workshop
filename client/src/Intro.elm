module Intro exposing (main)

import Html exposing (Html, button, span, div, text)


main : Html msg
main =
    div []
        [ button [] [ text "-" ]
        , span [] [ text "0" ]
        , button [] [ text "+" ]
        ]
