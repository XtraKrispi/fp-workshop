module Page.Home exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, text)
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Spacing as Spacing

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
view model = Grid.container [Spacing.mAuto] [text "Home Page"]