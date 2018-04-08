module Model exposing (..)

import Navigation exposing (Location)
import Routing exposing (Route)


type alias Model =
    { currentRoute : Route }


type Msg
    = OnLocationChange Location


type Sport
    = Hiking
    | Running
    | PullUps
    | PushUps
    | Boulder
    | Climbing


allSports : List Sport
allSports =
    [ Hiking
    , Running
    , PullUps
    , PushUps
    , Boulder
    , Climbing
    ]
