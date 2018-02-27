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
    | SquareSideChanged String
    | RectangleLengthChanged String
    | RectangleWidthChanged String


type Shape
    = Square Side
    | Rectangle Length Width


type alias Side =
    Int


type Length
    = Length Int


type Width
    = Width Int


type alias Model =
    Shape


main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }


model : Model
model =
    Rectangle (Length 0) (Width 0)


update : Msg -> Model -> Model
update msg model =
    let
        default str =
            str
                |> String.toInt
                |> Result.withDefault 0
    in
        case msg of
            SquareChecked ->
                Square 0

            RectangleChecked ->
                Rectangle (Length 0) (Width 0)

            SquareSideChanged str ->
                Square (default str)

            RectangleWidthChanged w ->
                case model of
                    Rectangle l _ ->
                        Rectangle l (Width (default w))

                    _ ->
                        model

            RectangleLengthChanged l ->
                case model of
                    Rectangle _ w ->
                        Rectangle (Length (default l)) w

                    _ ->
                        model


area : Shape -> Int
area shape =
    case shape of
        Square s ->
            s * s

        Rectangle (Length l) (Width w) ->
            w * l


view : Model -> Html Msg
view model =
    let
        shapeView =
            case model of
                Square side ->
                    div []
                        [ label [] [ text "Side Length: " ]
                        , input
                            [ type_ "number"
                            , value (toString side)
                            , onInput SquareSideChanged
                            ]
                            []
                        ]

                Rectangle (Length l) (Width w) ->
                    div []
                        [ label [] [ text "Length: " ]
                        , input
                            [ type_ "number"
                            , value (toString l)
                            , onInput RectangleLengthChanged
                            ]
                            []
                        , label [] [ text "Width: " ]
                        , input
                            [ type_ "number"
                            , value (toString w)
                            , onInput RectangleWidthChanged
                            ]
                            []
                        ]

        isChecked shape1 shape2 =
            case ( shape1, shape2 ) of
                ( Square _, Square _ ) ->
                    True

                ( Rectangle _ _, Rectangle _ _ ) ->
                    True

                ( Square _, _ ) ->
                    False

                ( Rectangle _ _, _ ) ->
                    False

        radioButton name_ label_ isChecked msg =
            label [ class "container" ]
                [ text label_
                , input
                    [ type_ "radio"
                    , name name_
                    , checked isChecked
                    , onCheck (always msg)
                    ]
                    []
                , span [ class "checkmark" ] []
                ]

        shapesRadioButton =
            radioButton "shapes"
    in
        div [ id "shapes-app" ]
            [ div []
                [ shapesRadioButton "Square" (isChecked (Square 0) model) SquareChecked
                , shapesRadioButton
                    "Rectangle"
                    (isChecked (Rectangle (Length 0) (Width 0)) model)
                    RectangleChecked
                ]
            , shapeView
            , div []
                [ span []
                    [ text ("Area: " ++ (toString <| area model))
                    ]
                ]
            ]
