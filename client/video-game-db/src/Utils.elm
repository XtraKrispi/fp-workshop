module Utils exposing (..)

import Html
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (Decoder)
import Date exposing (Date)


type alias HtmlElement msg =
    List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg


centered : HtmlElement msg -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
centered elem a h =
    elem (a ++ [ class "text-center" ]) h


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
