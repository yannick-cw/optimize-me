module Model exposing (..)

import Navigation exposing (Location)
import Routing exposing (Route)
import Sports exposing (Sport, TrackedSport, Metric)
import Dict exposing (Dict)


type alias Model =
    { currentRoute : Route
    , sports : List Sport
    , trackedSports : List TrackedSport
    , currentInputs : Dict String ( Metric, Float )
    }


type Msg
    = OnLocationChange Location
    | ClickSport Sport
    | NavigateTo String
    | AddTrackingEntry Sport
    | UpdateSportInputs Metric Float
