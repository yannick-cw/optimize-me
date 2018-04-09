module Model exposing (..)

import Navigation exposing (Location)
import Routing exposing (Route)


type alias Model =
    { currentRoute : Route, sports : List Sport }


type Msg
    = OnLocationChange Location
    | ClickSport Sport


type alias Sport =
    String


allSports : List Sport
allSports =
    [ "Hiking"
    , "Running"
    , "PullUps"
    , "PushUps"
    , "Boulder"
    , "Climbing"
    ]
