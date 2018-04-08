module View exposing (view)

import Html exposing (div, ul, li, Html, text, button, img, button, Attribute, a)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Css
import Markdown
import Model exposing (Model, Msg(..), Sport(..), allSports)
import Routing exposing (Route(..))


styles : List Css.Mixin -> Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


view : Model -> Html Msg
view m =
    div
        [ styles
            [ Css.margin Css.auto
            , Css.backgroundColor (Css.rgb 51 51 51)
            ]
        ]
        [ selectRouteView m ]


nav : Html msg
nav =
    let
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
                    , styles [ Css.fontSize (Css.px 20), Css.cursor Css.pointer, Css.color (Css.rgb 255 255 255) ]
                    ]
                    [ text msg ]
                ]
    in
        ul [ class "nav nav-pills nav-fill nav-light" ]
            [ item True "Track"
            , item False "Analyse"
            , item False "Goals"
            ]


sportsColours : Int -> List Css.Color
sportsColours numberOfColours =
    let
        colours =
            [ Css.rgb 16 69 71, Css.rgb 75 83 88, Css.rgb 114 112 114, Css.rgb 175 146 157, Css.rgb 210 214 239 ]

        countColours =
            List.length colours

        neededRepeats =
            ceiling ((toFloat numberOfColours) / (toFloat countColours))
    in
        List.repeat neededRepeats colours
            |> List.concat


sports : List Sport -> Html msg
sports sports =
    let
        sportBoxesStyles =
            styles [ Css.displayFlex, Css.flexWrap Css.wrap ]

        sportBoxStyles colour =
            styles
                [ Css.width (Css.vw 48)
                , Css.height (Css.vw 48)
                , Css.displayFlex
                , Css.flexDirection Css.column
                , Css.justifyContent Css.center
                , Css.backgroundColor colour
                , Css.marginTop (Css.px 6)
                , Css.marginLeft (Css.px 6)
                , Css.fontSize (Css.px 36)
                , Css.color (Css.rgb 255 255 255)
                ]

        renderedSports =
            sports |> List.map toString

        sportBoxes =
            List.map2 (,)
                ("+" :: renderedSports)
                (sportsColours (List.length sports))
                |> List.map (\( s, c ) -> div [ sportBoxStyles c ] [ text s ])
    in
        div [ sportBoxesStyles ] sportBoxes


selectRouteView : Model -> Html Msg
selectRouteView m =
    case m.currentRoute of
        Track ->
            div []
                [ nav, sports allSports ]

        NotFoundRoute ->
            notFoundView


notFoundView : Html msg
notFoundView =
    div [] [ text "Not Found" ]
