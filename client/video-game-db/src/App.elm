module App exposing (main)

import Html exposing (Html, text, div)
import Html.Attributes exposing (href, class)
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Color
import Navigation exposing (programWithFlags, Location)
import Routes as Routes exposing (Route)
import Page.Home as Home
import Page.Developers as Developers
import Page.Publishers as Publishers
import Page.Games as Games
import Ports
import Types exposing (BaseUrl)


-- Global state model for the entire application


type alias Model =
    { config : Config
    , navbarState : Navbar.State
    , currentPage : Page
    }



-- Any config that we need in the application lives here


type alias Config =
    { baseUrl : BaseUrl
    }


type Msg
    = NavbarMsg Navbar.State
    | ChangeRoute (Maybe Route)
    | HomePageMsg Home.Msg
    | DevelopersPageMsg Developers.Msg
    | PublishersPageMsg Publishers.Msg
    | GamesPageMsg Games.Msg



-- Pages represent the page and data for the given page.  A page
-- may or may not correspond to a route


type Page
    = Home Home.Model
    | Developers Developers.Model
    | Publishers Publishers.Model
    | Games Games.Model
    | NotFound
    | Blank



-- Pages for the purposes of the navigation bar, only used to determine what is
-- active at a given time


type NavPage
    = HomeNav
    | PublishersNav
    | DevelopersNav
    | GamesNav



-- A Navigation program works almost identically to a regular TEA program, but
-- you also specify a way to turn a Location (i.e. a url) into a Msg in your app


main : Program Config Model Msg
main =
    programWithFlags
        -- This notation is forward function composition (there's also << for the reverse direction).
        -- It allows us to create a new function (in this case Location -> Msg)
        -- without specifying how the data works through it
        -- The definition for composition is:
        --    (>>) : (a -> b) -> (b -> c) -> a -> c
        -- The navigation program expects a function of type:
        --    Location -> Msg
        --    Routes.fromLocation : Location -> Maybe Route
        --    ChangeRoute : Maybe Route -> Msg
        (Routes.fromLocation >> ChangeRoute)
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- With the programWithFlags program, init now takes in the Config value,
-- but also takes in the initial location due to the Navigation pacakge flavor of
-- programWithFlags


init : Config -> Location -> ( Model, Cmd Msg )
init config location =
    let
        -- This gets the initial state and any Cmds that the navbar component
        -- needs.  We don't care what they are, but we need them in case there's
        -- functionality that the component uses.
        -- This is a very common pattern in Elm for working with components.
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        -- Get the page, any Cmd for the page and the title of the page
        -- which we set with ports.
        -- We use Routes.fromLocation to turn the raw location into a route
        -- we can understand
        ( page, pageCmd, pageTitle ) =
            setRoute config (Routes.fromLocation location)
    in
        { config = config, navbarState = navbarState, currentPage = page }
            -- This syntax is a short form for
            -- (model, Cmd.batch [msgs])
            !
                [ navbarCmd, pageCmd, Ports.setPageTitle pageTitle ]



-- The navbar has subscriptions that must be bound. Notice that
-- we are wrapping all Navbar Msgs in NavbarMsg.  That allows us to
-- capture the msgs for passing to the update function while still keeping us in
-- our top level Msg type.  You'll see this a lot.


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- This will wire up any logic for the app itself, and execute logic for all pages.
-- Since TEA is a one way data flow, and the app is the entry point, in order for
-- the components to know of changes, the update function here acts as an
-- orchestrator to the update functions of the pages and/or child components.
-- Because of this, the app needs to know of it's direct children, but none of the
-- children need to know about the parent.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Capture messages intended for the navbar component
        NavbarMsg navbarState ->
            { model | navbarState = navbarState } ! []

        -- Change the route to the specified route.
        -- This message is used whenever the route changes based on how the
        -- programWithFlags was set up in main.
        ChangeRoute mRoute ->
            let
                ( page, cmd, title ) =
                    setRoute model.config mRoute
            in
                { model | currentPage = page } ! [ cmd, Ports.setPageTitle title ]

        -- Capture messages for the different pages.  Note that each follows a
        -- similar pattern.
        HomePageMsg msg ->
            case model.currentPage of
                Home m ->
                    let
                        ( newModel, cmd ) =
                            Home.update msg m
                    in
                        -- Cmd.map allows you to wrap the resulting Msg from a Cmd in another Msg.
                        -- This allows the child pages to define their own Msgs, but still allow
                        -- us to capture them in our top level Msg
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



-- This function will initialize a route, likely due to a location change in the
-- browser


setRoute : Config -> Maybe Route -> ( Page, Cmd Msg, String )
setRoute config mRoute =
    let
        getTitle title =
            "VgDB | " ++ title
    in
        case mRoute of
            Nothing ->
                ( NotFound, Cmd.none, getTitle "Page Not Found!" )

            Just (Routes.Home) ->
                let
                    ( model, cmd ) =
                        Home.init config
                in
                    ( Home model, Cmd.map HomePageMsg cmd, getTitle "Home" )

            Just (Routes.Developers) ->
                let
                    ( model, cmd ) =
                        Developers.init
                in
                    ( Developers model, Cmd.map DevelopersPageMsg cmd, getTitle "Developers" )

            Just (Routes.Publishers) ->
                let
                    ( model, cmd ) =
                        Publishers.init
                in
                    ( Publishers model, Cmd.map PublishersPageMsg cmd, getTitle "Publishers" )

            Just (Routes.Games) ->
                let
                    ( model, cmd ) =
                        Games.init
                in
                    ( Games model, Cmd.map GamesPageMsg cmd, getTitle "Games" )



-- Display the entire application, delegating the page's view to it's view function
-- We use the NavPage type here to tell the layout what the active nav is for
-- the view.
-- Notice that we're using partial application here on the layout function, so we
-- don't have to repeat the application of the navbar state to each branch of the case.


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



-- The main page layout, along with the active nav page (if any).
-- This places the navbar and the content on the page.


layout : Maybe NavPage -> Html Msg -> Navbar.State -> Html Msg
layout activePage content navbarState =
    div [] [ nav navbarState activePage, Grid.container [] [ content ] ]



-- Determines whether the current route matches the active page.
-- The reason we've separated the routing from the active page is to keep
-- all routing related logic together, where the highlight of the nav bar is a
-- little different.  This also allows for sub routes (i.e. an item specific page)
-- to be considered active for the purpose of highlighting on the navbar.


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
        -- You will see this kind of workflow for a lot of Elm components,
        -- where configuration is done as a pipeline, and the final application is
        -- what will render it as Html.  This allows for very nice configuration path
        -- that keeps things optional so you can pick and choose what to configure.
        Navbar.config NavbarMsg
            |> Navbar.withAnimation
            |> Navbar.darkCustom (Color.rgba 100 100 100 0.5)
            |> Navbar.fixTop
            |> Navbar.collapseLarge
            |> Navbar.brand [ class "brand", href "#" ] [ text "VgDB" ]
            |> Navbar.items (menuLinks)
            |> Navbar.view n
