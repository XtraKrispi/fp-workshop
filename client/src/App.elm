module App exposing (..)

import Html
    exposing
        ( Html
        , beginnerProgram
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
        )


type alias Model =
    {}


main : Program Never Model msg
main =
    beginnerProgram { model = {}, update = update, view = view }


update : msg -> Model -> Model
update _ model =
    model


view : Model -> Html msg
view _ =
    div []
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
                , ul [ class "todo-list" ]
                    [ li [ class "completed" ]
                        [ div [ class "view" ]
                            [ input [ class "toggle", type_ "checkbox", checked True ]
                                []
                            , label
                                []
                                [ text "Taste Elm" ]
                            , button
                                [ class "destroy" ]
                                []
                            ]
                        , input [ class "edit", value "Create a TodoMVC template" ] []
                        ]
                    , li []
                        [ div [ class "view" ]
                            [ input [ class "toggle", type_ "checkbox" ]
                                []
                            , label
                                []
                                [ text "Buy a unicorn" ]
                            , button
                                [ class "destroy" ]
                                []
                            ]
                        , input [ class "edit", value "Rule the web" ] []
                        ]
                    ]
                ]
            , footer [ class "footer" ]
                [ span [ class "todo-count" ]
                    [ strong [] [ text "0" ]
                    , text " items left"
                    ]
                , ul [ class "filters" ]
                    [ li []
                        [ a [ class "selected" ] [ text "All" ]
                        ]
                    , li []
                        [ a [] [ text "Active" ]
                        ]
                    , li []
                        [ a [] [ text "Completed" ]
                        ]
                    ]
                , button [ class "clear-completed" ] [ text "Clear completed" ]
                ]
            ]
        , footer [ class "info" ]
            [ p [] [ text "Double-click to edit a todo" ]
            , p [] [ text "Template by ", a [ href "http://sindresorhus.com" ] [ text "Sindre Sorhus" ] ]
            , p [] [ text "Created by ", a [ href "http://todomvc.com" ] [ text "Michael Gold" ] ]
            ]
        ]
