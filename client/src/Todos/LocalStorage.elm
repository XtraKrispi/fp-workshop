port module Todos.LocalStorage exposing (..)

import Json.Encode exposing (Value)


port setItem : ( String, Value ) -> Cmd msg


port requestItem : String -> Cmd msg


port itemFetched : (Value -> msg) -> Sub msg


port itemNotFound : (String -> msg) -> Sub msg
