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


type alias Developer = BasicInfo


type alias Publisher = BasicInfo


type From
    = From Int


type To
    = To Int


type Range
    = Range From To


type Game
    = Game
        { id : Int
        , title : String
        , numberOfPlayers : Range
        , publisher : Publisher
        , developer : Developer
        , lastModifiedDate : Date
        }

basicInfoDecoder : Decoder BasicInfo
basicInfoDecoder =
    decode BasicInfo
        |> required "id" int
        |> required "name" string 
        |> required "location" string
        |> required "lastModifiedDate" date
