module Page.Games exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, text)

type alias Model = {}

type Msg = NoOp

init : (Model, Cmd Msg)
init = {} ! []

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of 
    NoOp ->
      model ! []

view : Model -> Html Msg
view model = div [] [text "Games Page"]