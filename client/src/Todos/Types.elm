module Todos.Types exposing (..)

import Uuid exposing (Uuid)


type Status
    = Incomplete
    | Complete


type alias Todo =
    { description : String
    , status : Status
    }
