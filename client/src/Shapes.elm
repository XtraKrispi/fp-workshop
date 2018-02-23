module Shapes exposing (main)

import Html
    exposing
        ( Html
        , beginnerProgram
        , div
        , label
        , input
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


type Side
    = Side Int


type Length
    = Length Int


type Width
    = Width Int


type alias Model =
    { shape : Shape
    }


main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }


model : Model
model =
    { shape = Rectangle (Length 0) (Width 0)
    }


update : Msg -> Model -> Model
update msg model =
    let
        def =
            Result.withDefault 0 << String.toInt
    in
        case msg of
            SquareChecked ->
                { shape = Square (Side 0) }

            RectangleChecked ->
                { shape = Rectangle (Length 0) (Width 0) }

            SquareSideChanged str ->
                case model.shape of
                    Square _ ->
                        { model | shape = Square (Side (def str)) }

                    _ ->
                        model

            RectangleLengthChanged str ->
                case model.shape of
                    Rectangle _ w ->
                        { model | shape = Rectangle (Length (def str)) w }

                    _ ->
                        model

            RectangleWidthChanged str ->
                case model.shape of
                    Rectangle l _ ->
                        { model | shape = Rectangle l (Width (def str)) }

                    _ ->
                        model


area : Shape -> Int
area shape =
    case shape of
        Square (Side s) ->
            s * s

        Rectangle (Length l) (Width w) ->
            l * w


view : Model -> Html Msg
view model =
    let
        numberInput l val msg =
            div []
                [ label [] [ text l ]
                , input [ type_ "number", value val, onInput msg ] []
                ]

        shapeView =
            case model.shape of
                Square (Side side) ->
                    div []
                        [ numberInput "Side Length: " (toString side) SquareSideChanged
                        ]

                Rectangle (Length l) (Width w) ->
                    div []
                        [ numberInput "Length: " (toString l) RectangleLengthChanged
                        , numberInput "Width: " (toString w) RectangleWidthChanged
                        ]

        isChecked shape1 =
            case ( shape1, model.shape ) of
                ( Square _, Square _ ) ->
                    True

                ( Rectangle _ _, Rectangle _ _ ) ->
                    True

                ( Square _, _ ) ->
                    False

                ( Rectangle _ _, _ ) ->
                    False

        radio n l ic msg =
            label [ class "container" ]
                [ text l
                , input
                    [ type_ "radio"
                    , name n
                    , checked ic
                    , onCheck msg
                    ]
                    []
                , span [ class "checkmark" ] []
                ]

        shapesRadio =
            radio "shapes"
    in
        div [ id "shapes-app" ]
            [ div []
                [ shapesRadio "Square" (isChecked (Square (Side 0))) (always SquareChecked)
                , shapesRadio "Rectangle" (isChecked (Rectangle (Length 0) (Width 0))) (always RectangleChecked)
                ]
            , shapeView
            , div []
                [ span []
                    [ text ("Area: " ++ (toString <| area model.shape))
                    ]
                ]
            ]
