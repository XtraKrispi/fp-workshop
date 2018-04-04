module Page.Home exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, text, h2, ul, li, span)
import Html.Attributes exposing (class, style)
import Http exposing (Error)
import Task exposing (Task)
import Json.Decode as Decode


-- Notice the convention for importing the Elm Bootstrap libraries. They are
-- quite nested so aliasing them makes it easier to read

import Bootstrap.Grid as Grid
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Grid.Row as Row
import Bootstrap.ListGroup as ListGroup
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Utils exposing (centered, HtmlElement, loadingIndicator)
import RemoteData.Http exposing (get)


-- This is the Home page model.  It only ever contains information that this
-- specific page needs.
-- RemoteData is a datatype that encompasses data that can be in different states.
-- RemoteData is defined as:
--    type RemoteData err a =
--        NotAsked
--      | Loading
--      | Failure err
--      | Success a
-- We use WebData here, which is a more specific RemoteData:
--    type alias WebData a = RemoteData Http.Error a


type alias Model =
    { latestDevelopers : WebData (List Developer)
    , latestPublishers : WebData (List Publisher)
    , latestGames : WebData (List Game)
    }


type Msg
    = NoOp
    | LatestDevelopersResponse (WebData (List Developer))
    | LatestPublishersResponse (WebData (List Publisher))
    | LatestGamesResponse (WebData (List Game))


centeredDiv : HtmlElement Msg
centeredDiv =
    centered div



-- Initialize the page. We want all data to load on page load, so we
-- set their state to Loading, and make Http requests to load all of the data


init : { r | baseUrl : BaseUrl } -> ( Model, Cmd Msg )
init config =
    { latestPublishers = Loading
    , latestDevelopers = Loading
    , latestGames = Loading
    }
        ! [ getLatestPublishers config.baseUrl
          , getLatestDevelopers config.baseUrl
          , getLatestGames config.baseUrl
          ]



-- See how thin the update method is, because we are using RemoteData.Http, which
-- has helpers which automatically convert and Http response to WebData for us.
-- More complicated pages would have more logic here.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        LatestPublishersResponse resp ->
            { model | latestPublishers = resp } ! []

        LatestDevelopersResponse resp ->
            { model | latestDevelopers = resp } ! []

        LatestGamesResponse resp ->
            { model | latestGames = resp } ! []



-- View for a Basic Info record.  Renders as a list group item.
-- Notice the destructuring of the record to pull only the fields we want from the
-- record right into scope.


basicInfoView : BasicInfo -> ListGroup.Item Msg
basicInfoView { name, location } =
    ListGroup.li []
        [ Grid.row []
            [ Grid.col []
                [ span [ class "font-weight-bold" ] [ text name ]
                ]
            ]
        , Grid.row []
            [ Grid.col []
                [ span [ class "font-italic" ] [ text location ]
                ]
            ]
        ]



-- Renders the basic info view, taking into account the state of the WebData


basicInfoListView : WebData (List BasicInfo) -> Html Msg
basicInfoListView d =
    case d of
        NotAsked ->
            div [] []

        Loading ->
            div [] [ loadingIndicator ]

        Failure err ->
            div [] [ text <| "Error: " ++ (toString err) ]

        Success data ->
            case data of
                [] ->
                    div [] [ text "No data..." ]

                _ ->
                    ListGroup.ul <|
                        List.map basicInfoView data



-- Renders a game as a listgroup item.


gameView : Game -> ListGroup.Item Msg
gameView { title, yearPublished, minPlayers, maxPlayers, publisher } =
    ListGroup.li []
        [ Grid.row []
            [ Grid.col []
                [ span [ class "font-weight-bold" ] [ text title ]
                , span [ class "float-right" ] [ text (toString yearPublished) ]
                ]
            ]
        , Grid.row []
            [ Grid.col []
                [ span
                    [ class "font-italic"
                    ]
                    [ text <|
                        "# of players: "
                            ++ (toString minPlayers ++ " - " ++ toString maxPlayers)
                    ]
                , span
                    [ class "float-right"
                    ]
                    [ text publisher.name
                    ]
                ]
            ]
        ]



-- Renders the WebData for a list of games, taking into account the state
-- of the data.


gamesView : WebData (List Game) -> Html Msg
gamesView d =
    case d of
        NotAsked ->
            div [] []

        Loading ->
            div [] [ loadingIndicator ]

        Failure err ->
            div [] [ text <| "Error: " ++ (toString err) ]

        Success data ->
            case data of
                [] ->
                    div [] [ text "No data..." ]

                _ ->
                    ListGroup.ul <|
                        List.map gameView data



-- Render the page.  note that we use Bootstrap's Grid and Cards here to
-- achieve a decent look (without any extra css).


view : Model -> Html Msg
view model =
    div []
        [ Grid.row [ Row.attrs [ Spacing.mb5 ] ]
            [ Grid.col []
                [ centeredDiv [ class "display-2" ] [ text "Home" ]
                ]
            ]
        , Grid.row []
            [ Grid.col []
                [ Card.config [ Card.light ]
                    |> Card.headerH2 [] [ text "Latest Developers" ]
                    |> Card.block [] [ Block.custom <| basicInfoListView model.latestDevelopers ]
                    |> Card.view
                ]
            , Grid.col []
                [ Card.config [ Card.light ]
                    |> Card.headerH2 [] [ text "Latest Publishers" ]
                    |> Card.block [] [ Block.custom <| basicInfoListView model.latestPublishers ]
                    |> Card.view
                ]
            , Grid.col []
                [ Card.config [ Card.light ]
                    |> Card.headerH2 [] [ text "Latest Games" ]
                    |> Card.block [] [ Block.custom <| gamesView model.latestGames ]
                    |> Card.view
                ]
            ]
        ]



-- These constants define the endpoints for the various web services


publishersEndpoint : String
publishersEndpoint =
    "publishers"


developersEndpoint : String
developersEndpoint =
    "developers"


gamesEndpoint : String
gamesEndpoint =
    "games"



-- These functions use the RemoteData.Http get method to define a Cmd to make a
-- request and, using the decoder, automatically convert it to WebData and call
-- the appropriate Msg.


getLatestPublishers : BaseUrl -> Cmd Msg
getLatestPublishers baseUrl =
    get (baseUrl ++ publishersEndpoint) LatestPublishersResponse (Decode.list basicInfoDecoder)


getLatestDevelopers : BaseUrl -> Cmd Msg
getLatestDevelopers baseUrl =
    get (baseUrl ++ developersEndpoint) LatestDevelopersResponse (Decode.list basicInfoDecoder)


getLatestGames : BaseUrl -> Cmd Msg
getLatestGames baseUrl =
    get (baseUrl ++ gamesEndpoint) LatestGamesResponse (Decode.list gameDecoder)
