module Page.Home exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, text, h2, ul, li, span)
import Html.Attributes exposing (class)
import Http exposing (Error)
import Task exposing (Task)
import Json.Decode as Decode
import Bootstrap.Grid as Grid
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Grid.Row as Row
import Bootstrap.ListGroup as ListGroup
import RemoteData exposing (WebData, RemoteData(..))
import Types exposing (..)
import Utils exposing (centered, HtmlElement)
import RemoteData.Http exposing (get)


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


init : { r | baseUrl : BaseUrl } -> ( Model, Cmd Msg )
init config =
    { latestPublishers = Loading
    , latestDevelopers = NotAsked
    , latestGames = NotAsked
    }
        ! [ getLatestPublishers config.baseUrl
          , getLatestDevelopers config.baseUrl
          ]


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


basicInfoListView : WebData (List BasicInfo) -> Html Msg
basicInfoListView d =
    case d of
        NotAsked ->
            div [] []

        Loading ->
            div [] [ text "Loading..." ]

        Failure err ->
            div [] [ text <| "Error: " ++ (toString err) ]

        Success data ->
            case data of
                [] ->
                    div [] [ text "No data..." ]

                _ ->
                    ListGroup.ul <|
                        List.map basicInfoView data


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
                    |> Card.block [] []
                    |> Card.view
                ]
            ]
        ]


publishersEndpoint : String
publishersEndpoint =
    "publishers"


developersEndpoint : String
developersEndpoint =
    "developers"


getLatestPublishers : BaseUrl -> Cmd Msg
getLatestPublishers baseUrl =
    get (baseUrl ++ publishersEndpoint) LatestPublishersResponse (Decode.list basicInfoDecoder)


getLatestDevelopers : BaseUrl -> Cmd Msg
getLatestDevelopers baseUrl =
    get (baseUrl ++ developersEndpoint) LatestDevelopersResponse (Decode.list basicInfoDecoder)
