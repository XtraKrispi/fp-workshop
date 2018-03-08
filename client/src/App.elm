module App exposing (main)

import Html
    exposing
        ( Html
        , program
        , div
        , text
        , section
        , header
        , input
        , h1
        , label
        , ul
        , li
        , button
        , footer
        , span
        , strong
        , a
        , p
        )
import Html.Attributes
    exposing
        ( class
        , placeholder
        , autofocus
        , id
        , type_
        , for
        , checked
        , value
        , href
        , classList
        )
import Html.Events exposing (onClick, onCheck)


type Status
    = Incomplete
    | Complete


type alias Todo =
    { description : String
    , status : Status
    }


type alias Model =
    { todos : List Todo
    , currentFilter : Maybe Status
    }


type Msg
    = ChangeFilter (Maybe Status)
    | ClearCompleted
    | UpdateStatus Todo Status


main : Program Never Model Msg
main =
    program { init = init, update = update, view = view, subscriptions = subscriptions }


init : ( Model, Cmd Msg )
init =
    ( { todos =
            [ { description = "Task 1", status = Complete }
            , { description = "Buy a unicorn", status = Incomplete }
            , { description = "Learn Elm", status = Complete }
            , { description = "Profit", status = Incomplete }
            ]
      , currentFilter = Nothing
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


filterIncomplete : List { r | status : Status } -> List { r | status : Status }
filterIncomplete =
    List.filter (\todo -> todo.status == Incomplete)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeFilter newFilter ->
            ( { model | currentFilter = newFilter }, Cmd.none )

        ClearCompleted ->
            ( { model | todos = filterIncomplete model.todos }, Cmd.none )

        UpdateStatus todo status ->
            let
                mapFn t =
                    if (t == todo) then
                        { t | status = status }
                    else
                        t
            in
                ( { model | todos = List.map mapFn model.todos }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        filterFn todo =
            case ( model.currentFilter, todo.status ) of
                ( Nothing, _ ) ->
                    True

                ( Just status, todoStatus ) ->
                    status == todoStatus

        filteredTodos =
            List.filter filterFn model.todos

        incompleteTodos =
            filterIncomplete filteredTodos
    in
        div [ id "todo-app" ]
            [ section [ class "todoapp" ]
                [ header [ class "header" ]
                    [ h1 []
                        [ text "todos" ]
                    , input
                        [ class "new-todo", placeholder "What needs to be done?", autofocus True ]
                        []
                    ]
                , section [ class "main" ]
                    [ input [ id "toggle-all", class "toggle-all", type_ "checkbox" ] []
                    , label [ for "toggle-all" ] [ text "Mark all as complete" ]
                    , ul [ class "todo-list" ] <| List.map todoListItem filteredTodos
                    ]
                , footer [ class "footer" ]
                    [ span [ class "todo-count" ]
                        [ strong [] [ text (toString <| List.length incompleteTodos) ]
                        , text " items left"
                        ]
                    , ul [ class "filters" ]
                        [ li []
                            [ a
                                [ classList [ ( "selected", model.currentFilter == Nothing ) ]
                                , onClick (ChangeFilter Nothing)
                                ]
                                [ text "All" ]
                            ]
                        , li []
                            [ a
                                [ classList [ ( "selected", model.currentFilter == Just Incomplete ) ]
                                , onClick (ChangeFilter (Just Incomplete))
                                ]
                                [ text "Active" ]
                            ]
                        , li []
                            [ a
                                [ classList [ ( "selected", model.currentFilter == Just Complete ) ]
                                , onClick (ChangeFilter (Just Complete))
                                ]
                                [ text "Completed" ]
                            ]
                        ]
                    , button [ class "clear-completed", onClick ClearCompleted ] [ text "Clear completed" ]
                    ]
                ]
            , footer [ class "info" ]
                [ p [] [ text "Double-click to edit a todo" ]
                , p [] [ text "Template by ", a [ href "http://sindresorhus.com" ] [ text "Sindre Sorhus" ] ]
                , p [] [ text "Created by ", a [ href "http://todomvc.com" ] [ text "Michael Gold" ] ]
                ]
            ]


todoListItem : Todo -> Html Msg
todoListItem todo =
    let
        isComplete =
            todo.status == Complete
    in
        li [ classList [ ( "completed", isComplete ) ] ]
            [ div [ class "view" ]
                [ input
                    [ class "toggle"
                    , type_ "checkbox"
                    , checked isComplete
                    , onCheck
                        (always <|
                            UpdateStatus todo
                                (if isComplete then
                                    Incomplete
                                 else
                                    Complete
                                )
                        )
                    ]
                    []
                , label
                    []
                    [ text todo.description ]
                , button
                    [ class "destroy" ]
                    []
                ]
            , input [ class "edit", value todo.description ] []
            ]
