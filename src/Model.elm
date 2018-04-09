module Model exposing (..)

import Navigation exposing (Location)
import Routing exposing (Route)
import Sports exposing (Sport)


type alias Model =
    { currentRoute : Route, sports : List Sport }


type Msg
    = OnLocationChange Location
    | ClickSport Sport
    | NavigateTo String
