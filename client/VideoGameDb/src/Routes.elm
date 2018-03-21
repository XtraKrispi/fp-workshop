module Routes exposing (Route(..), fromLocation, routeToString)

import Navigation exposing (Location)
import UrlParser  as Url exposing (parseHash, Parser, oneOf, s)

type Route
    = Home
    | Publishers
    | Developers
    | Games

route : Parser (Route -> a) a
route = 
    oneOf [
        Url.map Home (s "")
        ,Url.map Publishers (s "publishers")
        ,Url.map Developers (s "developers")
        ,Url.map Games (s "games")
    ]

fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash route location

routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Publishers ->
                    ["publishers"]
                Developers ->
                    ["developers"]
                Games ->
                    ["games"]
    in
    "#/" ++ String.join "/" pieces        