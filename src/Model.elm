module Model exposing (..)

import Navigation exposing (Location)
import Routing exposing (Route)
import Sports exposing (Sport, TrackedSport, Metric)
import Dict exposing (Dict)
import Time exposing (Time)
import Date exposing (Date)
import Http


type Model
    = NotLoggedIn
    | LoggedIn LoggedInModel


type alias LoggedInModel =
    { userId : String
    , currentRoute : Route
    , currentDate : Maybe Date
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
    | Tick Time
    | User (Result Http.Error String)
