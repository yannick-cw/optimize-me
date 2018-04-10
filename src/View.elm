module View exposing (view)

import Html.Styled exposing (div, ul, li, Html, text, button, img, button, Attribute, a, i, span, td, input, table, thead, tr, th, tbody)
import Html.Styled.Attributes exposing (class, css, placeholder, type_, value, scope)
import Html.Styled.Events exposing (onClick, onInput)
import Css
import ListHelper exposing (find)
import Model exposing (Model, Msg(..))
import Sports exposing (Sport, allSports, renderMetric, TrackedSport, renderUnit)
import Routing exposing (Route(..))


view : Model -> Html Msg
view m =
    div
        [ css
            [ Css.margin Css.auto
            , Css.position Css.absolute
            , Css.left (Css.px 0)
            , Css.right (Css.px 0)
            , Css.maxWidth (Css.px 830)
            , Css.backgroundColor (Css.rgb 51 51 51)
            , Css.minHeight (Css.pct 100)
            ]
        ]
        (selectRouteView m)


nav : Html msg
nav =
    let
        navStyles =
            css [ Css.marginLeft (Css.px 6), Css.marginRight (Css.px 6) ]

        navItemStyles =
            css [ Css.fontSize (Css.px 20), Css.cursor Css.pointer, Css.color (Css.rgb 255 255 255) ]

        item active msg =
            li [ class "nav-item" ]
                [ a
                    [ class
                        ("nav-link"
                            ++ if active then
                                " active"
                               else
                                ""
                        )
                    , navItemStyles
                    ]
                    [ text msg ]
                ]
    in
        ul [ class "nav nav-pills nav-fill nav-light", navStyles ]
            [ item True "Track"
            , item False "Analyse"
            , item False "Goals"
            ]


sportsColours : Int -> List ( Css.Color, Css.Color )
sportsColours numberOfColours =
    let
        colours =
            [ ( 16, 69, 71 )
            , ( 75, 83, 88 )
            , ( 114, 112, 114 )
            , ( 175, 146, 157 )
            , ( 210, 214, 239 )
            ]
                |> List.map (\( r, g, b ) -> ( Css.rgba r g b 0.5, Css.rgba r g b 1 ))

        countColours =
            List.length colours

        neededRepeats =
            ceiling ((toFloat numberOfColours) / (toFloat countColours))
    in
        List.repeat neededRepeats colours
            |> List.concat


sports : List Sport -> Html Msg
sports sports =
    let
        sportBoxesStyles =
            css [ Css.displayFlex, Css.flexWrap Css.wrap ]

        sportBoxStyles colour =
            css
                [ Css.width (Css.vw 48)
                , Css.maxWidth (Css.px 200)
                , Css.height (Css.vw 48)
                , Css.maxHeight (Css.px 200)
                , Css.displayFlex
                , Css.flexDirection Css.column
                , Css.justifyContent Css.center
                , Css.marginTop (Css.px 6)
                , Css.marginLeft (Css.px 6)
                , Css.fontSize (Css.px 36)
                , Css.color (Css.rgb 255 255 255)
                , Css.backgroundImage <|
                    Css.linearGradient2 Css.toRight (Css.stop (Tuple.first colour)) (Css.stop (Tuple.second colour)) []
                ]

        sportBox colour sport =
            div [ sportBoxStyles colour, onClick <| ClickSport sport ] [ text sport.name ]

        sportBoxes =
            List.map2 (,)
                sports
                (sportsColours (List.length sports))
                |> List.map (\( s, c ) -> sportBox c s)
    in
        div [ sportBoxesStyles ] sportBoxes


sportPage : Sport -> List TrackedSport -> Html Msg
sportPage s history =
    let
        backArrowWidth =
            Css.px 46

        backArrow =
            i
                [ class "material-icons"
                , css [ Css.fontSize backArrowWidth ]
                , onClick <| NavigateTo "/track"
                ]
                [ text "arrow_back" ]

        title =
            span [] [ text s.name ]

        headerStyles =
            css
                [ Css.displayFlex
                , Css.alignItems Css.center
                , Css.justifyContent Css.spaceBetween
                , Css.backgroundColor (Css.rgb 128 128 128)
                , Css.marginTop (Css.px 6)
                ]

        header =
            div [ headerStyles ] [ backArrow, title, div [ css [ Css.width backArrowWidth ] ] [] ]

        validateInput text =
            case String.toFloat text of
                Ok num ->
                    num

                Err _ ->
                    0

        sportInput metric =
            input
                [ class "form-control"
                , type_ "number"
                , onInput (\input -> (UpdateSportInputs metric (validateInput input)))
                , placeholder <| renderMetric metric
                , css [ Css.fontSize (Css.px 16) ]
                ]
                []

        newInputs =
            s.inputs |> List.map sportInput

        addBtn =
            i
                [ class "material-icons"
                , css [ Css.fontSize backArrowWidth, Css.marginLeft (Css.px 16) ]
                , css [ Css.fontSize backArrowWidth, Css.marginRight (Css.px 16) ]
                , onClick (AddTrackingEntry s)
                ]
                [ text "add_circle_outline" ]

        newInputStyles =
            css [ Css.displayFlex, Css.flexWrap Css.wrap, Css.flexDirection Css.column, Css.width (Css.pct 100) ]

        newInput =
            div [ newInputStyles ] newInputs

        inputWithAdd =
            div
                [ css
                    [ Css.displayFlex
                    , Css.alignItems Css.center
                    , Css.marginLeft (Css.px 6)
                    ]
                ]
                [ newInput, addBtn ]

        columnNames =
            s.inputs |> List.map .name

        historyColumns =
            (th [ scope "col" ] [ text "date" ]) :: (columnNames |> List.map (\n -> th [ scope "col" ] [ text n ]))

        matchTrackedDataToColumns trackedSport column =
            trackedSport.trackedData
                |> find (\data -> (Tuple.first data).name == column.name)
                |> Maybe.map (\( metric, value ) -> (toString value) ++ " " ++ (renderUnit metric.unit))
                |> Maybe.withDefault ("0 " ++ (renderUnit column.unit))

        dateAdded =
            th [ scope "row" ] [ text "21.3.2018" ]

        historyItem trackedSport =
            tr []
                (dateAdded
                    :: (s.inputs
                            |> List.map (matchTrackedDataToColumns trackedSport)
                            |> List.map (\renderedData -> td [ css [ Css.textAlign Css.left ] ] [ text renderedData ])
                       )
                )

        historyBox =
            history |> List.filter (\ts -> ts.sport.name == s.name) |> List.map historyItem

        historyTable =
            table [ class "table table-dark" ] [ thead [] [ tr [] historyColumns ], tbody [] historyBox ]
    in
        div []
            [ header
            , div [] [ text "Track", inputWithAdd ]
            , div [] [ text "History" ]
            , div [] [ historyTable ]
            ]


selectRouteView : Model -> List (Html Msg)
selectRouteView m =
    case m.currentRoute of
        Home ->
            []

        Track ->
            [ nav, sports allSports ]

        TrackSport s ->
            [ nav, sportPage s m.trackedSports ]

        NotFoundRoute ->
            [ notFoundView ]


notFoundView : Html msg
notFoundView =
    div [] [ text "Not Found" ]
