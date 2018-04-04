port module Ports exposing (setPageTitle)

-- This port will set the title of the page.  There is no built in way to do this
-- in Elm, so we make a simple port to do it.


port setPageTitle : String -> Cmd msg
