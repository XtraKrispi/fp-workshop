module Types exposing (..)

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (..)
import Utils exposing (date)


type alias BaseUrl =
    String


type alias BasicInfo =
    { id : Int
    , name : String
    , location : String
    , lastModifiedDate : Date
    }


type alias Developer =
    BasicInfo


type alias Publisher =
    BasicInfo


type alias Game =
    { id : Int
    , title : String
    , yearPublished : Int
    , minPlayers : Int
    , maxPlayers : Int
    , publisher : Publisher
    , developer : Developer
    , lastModifiedDate : Date
    }



-- These decoders use the elm-decode-pipeline package to describe how to turn
-- json into Elm types


basicInfoDecoder : Decoder BasicInfo
basicInfoDecoder =
    decode BasicInfo
        |> required "id" int
        |> required "name" string
        |> required "location" string
        |> required "lastModifiedDate" date


gameDecoder : Decoder Game
gameDecoder =
    decode Game
        |> required "id" int
        |> required "title" string
        |> required "yearPublished" int
        |> required "minPlayers" int
        |> required "maxPlayers" int
        |> required "publisher" basicInfoDecoder
        |> required "developer" basicInfoDecoder
        |> required "lastModifiedDate" date
