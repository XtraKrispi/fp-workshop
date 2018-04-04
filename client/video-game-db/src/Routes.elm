module Routes exposing (Route(..), fromLocation, routeToString)

import Navigation exposing (Location)
import UrlParser as Url exposing (parseHash, Parser, oneOf, s)


-- This module defines the different routes (corresponding to the url)
-- and how we handle them in the application.


type Route
    = Home
    | Publishers
    | Developers
    | Games



-- A url parser for mapping a url to a route.
-- oneOf will try to parse from the top down.


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        , Url.map Publishers (s "publishers")
        , Url.map Developers (s "developers")
        , Url.map Games (s "games")
        ]



-- Turns a location into a route, based on the hash.
-- This will run the parser defined above on the hash of the url.


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash route location



-- Converts a route into a string, including any pieces that must be put into
-- the url. We can use this string in <a href> tags for redirection.
-- Navigation also allows programmatic navigation but we haven't used it yet, as
-- it would only be necessary from the update function.


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Publishers ->
                    [ "publishers" ]

                Developers ->
                    [ "developers" ]

                Games ->
                    [ "games" ]
    in
        "#/" ++ String.join "/" pieces
