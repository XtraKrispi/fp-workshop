module Todos.Types exposing (..)

import Uuid exposing (Uuid)
import Json.Decode as Decode
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (..)

type Status
    = Incomplete
    | Complete


type alias Todo =
    { id : Uuid
    , description : String
    , status : Status
    }

statusDecoder : Decode.Decoder Status
statusDecoder = 
    let helper s =
            case s of 
                "complete" -> Complete
                _ -> Incomplete
    in Decode.map helper Decode.string 


todoDecoder : Decode.Decoder Todo
todoDecoder = 
    decode Todo
    |> required "id" Uuid.decoder
    |> required "description" Decode.string
    |> required "status" statusDecoder

encodeTodo : Todo -> Encode.Value
encodeTodo todo = 
    let value = Encode.object [
        ("id", Uuid.encode todo.id)
        ,("description", Encode.string todo.description)
        ,("status", Encode.string <| String.toLower <| toString todo.status)
    ]
    in Debug.log "value" value
