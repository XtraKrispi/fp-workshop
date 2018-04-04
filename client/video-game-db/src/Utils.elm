module Utils exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import Json.Decode as Decode exposing (Decoder)
import Date exposing (Date)


type alias HtmlElement msg =
    List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg



-- Uses bootstrap classes to create a center aligned element.  We abstract away
-- the Html element type as HtmlElement so we maintain a similar signature to
-- regular Elm html elements


centered : HtmlElement msg -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
centered elem a h =
    elem (a ++ [ class "text-center" ]) h



-- Decoder for dates. There isn't one built in, so we make our own here


date : Decoder Date
date =
    Decode.andThen
        (\s ->
            case Date.fromString s of
                Ok d ->
                    Decode.succeed d

                Err e ->
                    Decode.fail "Invalid date"
        )
        Decode.string



-- Loading indicator Html element


loadingIndicator : Html msg
loadingIndicator =
    div [ class "lds-css" ]
        [ div
            [ class "lds-pacman"
            , style [ ( "width", "100%" ), ( "height", "100%" ), ( "margin", "0 auto" ) ]
            ]
            [ div [] (List.repeat 3 (div [] []))
            , div [] (List.repeat 2 (div [] []))
            ]
        ]
