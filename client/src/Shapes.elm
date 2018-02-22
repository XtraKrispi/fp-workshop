module Shapes exposing (main)

import Html
    exposing
        ( Html
        , beginnerProgram
        , div
        , input
        , label
        , text
        , span
        )
import Html.Attributes exposing (type_, name, checked, value, id, class)
import Html.Events exposing (onCheck, onInput)


type Msg
    = SquareChecked
    | RectangleChecked
    | Side1Changed Int
    | Side2Changed Int


type Shape
    = Square
    | Rectangle


type alias Side1 =
    Int


type alias Side2 =
    Int


type alias Model =
    { shape : Shape
    , side1 : Side1
    , side2 : Maybe Side2
    }


main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }


model : Model
model =
    { shape = Rectangle
    , side1 = 0
    , side2 = Just 0
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SquareChecked ->
            { shape = Square, side1 = 0, side2 = Nothing }

        RectangleChecked ->
            { shape = Rectangle, side1 = 0, side2 = Just 0 }

        Side1Changed a ->
            { model | side1 = a }

        Side2Changed a ->
            { model | side2 = Just a }


area : Shape -> Side1 -> Maybe Side2 -> Int
area shape s1 s2 =
    case shape of
        Square ->
            s1 * s1

        Rectangle ->
            s1 * (Maybe.withDefault 0 s2)


view : Model -> Html Msg
view model =
    let
        side2Normal =
            model.side2
                |> Maybe.withDefault 0
                |> toString

        shapeView =
            case model.shape of
                Square ->
                    div []
                        [ label [] [ text "Side Length: " ]
                        , input
                            [ type_ "number"
                            , value (toString model.side1)
                            , onInput
                                (\s ->
                                    s
                                        |> String.toInt
                                        |> Result.withDefault 0
                                        |> Side1Changed
                                )
                            ]
                            []
                        ]

                Rectangle ->
                    div []
                        [ label [] [ text "Length: " ]
                        , input
                            [ type_ "number"
                            , value (toString model.side1)
                            , onInput
                                (\s ->
                                    s
                                        |> String.toInt
                                        |> Result.withDefault 0
                                        |> Side1Changed
                                )
                            ]
                            []
                        , label [] [ text "Width: " ]
                        , input
                            [ type_ "number"
                            , value side2Normal
                            , onInput
                                (\s ->
                                    s
                                        |> String.toInt
                                        |> Result.withDefault 0
                                        |> Side2Changed
                                )
                            ]
                            []
                        ]

        isChecked shape1 shape2 =
            case ( shape1, shape2 ) of
                ( Square, Square ) ->
                    True

                ( Rectangle, Rectangle ) ->
                    True

                _ ->
                    False
    in
        div [ id "shapes-app" ]
            [ div []
                [ label [ class "container" ]
                    [ text "Square"
                    , input
                        [ type_ "radio"
                        , name "shapes"
                        , checked (isChecked Square model.shape)
                        , onCheck (\_ -> SquareChecked)
                        ]
                        []
                    , span [ class "checkmark" ] []
                    ]
                , label [ class "container" ]
                    [ text "Rectangle"
                    , input
                        [ type_ "radio"
                        , name "shapes"
                        , checked (isChecked Rectangle model.shape)
                        , onCheck (\_ -> RectangleChecked)
                        ]
                        []
                    , span [ class "checkmark" ] []
                    ]
                ]
            , shapeView
            , div []
                [ span []
                    [ text ("Area: " ++ (toString <| area model.shape model.side1 model.side2))
                    ]
                ]
            ]
