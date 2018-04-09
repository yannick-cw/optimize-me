module View exposing (view)

import Html.Styled exposing (div, ul, li, Html, text, button, img, button, Attribute, a)
import Html.Styled.Attributes exposing (class, css)
import Html.Styled.Events exposing (onClick)
import Css
import Model exposing (Model, Msg(..), Sport, allSports)
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
            , Css.height (Css.pct 100)
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
            div [ sportBoxStyles colour, onClick <| ClickSport sport ] [ text sport ]

        sportBoxes =
            List.map2 (,)
                ("+" :: sports)
                (sportsColours (List.length sports))
                |> List.map (\( s, c ) -> sportBox c s)
    in
        div [ sportBoxesStyles ] sportBoxes


selectRouteView : Model -> List (Html Msg)
selectRouteView m =
    case m.currentRoute of
        Home ->
            []

        Track ->
            [ nav, sports allSports ]

        TrackSport sportName ->
            [ nav, div [] [ text sportName ] ]

        NotFoundRoute ->
            [ notFoundView ]


notFoundView : Html msg
notFoundView =
    div [] [ text "Not Found" ]
