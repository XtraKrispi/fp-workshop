module App exposing (main)

import Html exposing (Html, text, div)
import Html.Attributes exposing (href, class)
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Color
import Navigation exposing (program, Location)
import Routes as Routes exposing (Route)
import Page.Home as Home
import Page.Developers as Developers
import Page.Publishers as Publishers
import Page.Games as Games


type alias Model =
    { navbarState : Navbar.State
    , currentPage : Page
    }


type Msg
    = NavbarMsg Navbar.State
    | ChangeRoute (Maybe Route)
    | HomePageMsg Home.Msg
    | DevelopersPageMsg Developers.Msg
    | PublishersPageMsg Publishers.Msg
    | GamesPageMsg Games.Msg


type Page
    = Home Home.Model
    | Developers Developers.Model
    | Publishers Publishers.Model
    | Games Games.Model
    | NotFound
    | Blank


type NavPage
    = HomeNav
    | PublishersNav
    | DevelopersNav
    | GamesNav


main : Program Never Model Msg
main =
    program (Routes.fromLocation >> ChangeRoute) { init = init, update = update, subscriptions = subscriptions, view = view }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        ( page, pageCmd ) =
            setRoute (Routes.fromLocation location)
    in
        { navbarState = navbarState, currentPage = page } ! [ navbarCmd, pageCmd ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarState ->
            { model | navbarState = navbarState } ! []

        ChangeRoute mRoute ->
            let
                ( page, cmd ) =
                    setRoute mRoute
            in
                { model | currentPage = page } ! [ cmd ]

        HomePageMsg msg ->
            case model.currentPage of
                Home m ->
                    let
                        ( newModel, cmd ) =
                            Home.update msg m
                    in
                        { model | currentPage = Home newModel } ! [ Cmd.map HomePageMsg cmd ]

                _ ->
                    model ! []
        DevelopersPageMsg msg ->
            case model.currentPage of
                Developers m ->
                    let
                        ( newModel, cmd ) =
                            Developers.update msg m
                    in
                        { model | currentPage = Developers newModel } ! [ Cmd.map DevelopersPageMsg cmd ]

                _ ->
                    model ! []
        PublishersPageMsg msg ->
            case model.currentPage of
                Publishers m ->
                    let
                        ( newModel, cmd ) =
                            Publishers.update msg m
                    in
                        { model | currentPage = Publishers newModel } ! [ Cmd.map PublishersPageMsg cmd ]

                _ ->
                    model ! []
        GamesPageMsg msg ->
            case model.currentPage of
                Games m ->
                    let
                        ( newModel, cmd ) =
                            Games.update msg m
                    in
                        { model | currentPage = Games newModel } ! [ Cmd.map GamesPageMsg cmd ]

                _ ->
                    model ! []

setRoute : Maybe Route -> ( Page, Cmd Msg )
setRoute mRoute =
    case mRoute of
        Nothing ->
            NotFound ! []

        Just Routes.Home ->
            let
                ( model, cmd ) =
                    Home.init
            in
                Home model ! [ Cmd.map HomePageMsg cmd ]

        Just Routes.Developers -> 
            let
                ( model, cmd ) =
                    Developers.init
            in
                Developers model ! [ Cmd.map DevelopersPageMsg cmd ]
        Just Routes.Publishers -> 
            let
                ( model, cmd ) =
                    Publishers.init
            in
                Publishers model ! [ Cmd.map PublishersPageMsg cmd ]
        Just Routes.Games -> 
            let
                ( model, cmd ) =
                    Games.init
            in
                Games model ! [ Cmd.map GamesPageMsg cmd ]

view : Model -> Html Msg
view model =
    let
        laidOut = 
            case model.currentPage of
                Home m ->
                    let
                        v =
                            Home.view m
                    in
                        layout (Just HomeNav) <| Html.map HomePageMsg v

                Developers m ->
                    let
                        v =
                            Developers.view m
                    in
                        layout (Just DevelopersNav) <| Html.map DevelopersPageMsg v
                Publishers m ->
                    let
                        v =
                            Publishers.view m
                    in
                        layout (Just PublishersNav) <| Html.map PublishersPageMsg v
                Games m ->
                    let
                        v =
                            Games.view m
                    in
                        layout (Just GamesNav) <| Html.map GamesPageMsg v
                NotFound ->
                    layout Nothing (div [] [ text "Not Found" ])

                Blank ->
                    layout Nothing (div [] [])
    in
        laidOut model.navbarState


layout : Maybe NavPage -> Html Msg -> Navbar.State -> Html Msg
layout activePage content navbarState =
    div [] [ nav navbarState activePage, Grid.container [] [ content ] ]


isActive : Maybe NavPage -> Route -> Bool
isActive activePage route =
    case ( activePage, route ) of
        ( Just HomeNav, Routes.Home ) ->
            True

        ( Just DevelopersNav, Routes.Developers ) ->
            True

        ( Just PublishersNav, Routes.Publishers ) ->
            True

        ( Just GamesNav, Routes.Games ) ->
            True

        _ ->
            False


nav : Navbar.State -> Maybe NavPage -> Html Msg
nav n activePage =
    let
        menuItems =
            [ ( "Home", Routes.Home ), ( "Publishers", Routes.Publishers ), ( "Developers", Routes.Developers ), ( "Games", Routes.Games ) ]

        menuLinks =
            menuItems
                |> List.map
                    (\( desc, route ) ->
                        (if isActive activePage route then
                            Navbar.itemLinkActive
                         else
                            Navbar.itemLink
                        )
                            [ href <| Routes.routeToString route ]
                            [ text desc ]
                    )
    in
        Navbar.config NavbarMsg
            |> Navbar.withAnimation
            |> Navbar.darkCustom (Color.rgba 100 100 100 0.5)
            |> Navbar.fixTop
            |> Navbar.collapseLarge
            |> Navbar.brand [class "brand", href "#" ] [ text "VgDB" ]
            |> Navbar.items (menuLinks)
            |> Navbar.view n
