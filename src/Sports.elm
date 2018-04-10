module Sports exposing (..)


type alias Sport =
    { name : String, inputs : List Metric }


type alias TrackedSport =
    { sport : Sport, trackedData : List ( Metric, Float ) }


type alias Metric =
    { name : String, unit : Unit }


type Unit
    = Km
    | Meter
    | Time Duration
    | Repetitions


type Duration
    = Hours
    | Minutes


renderUnit : Unit -> String
renderUnit unit =
    case unit of
        Km ->
            "km"

        Meter ->
            "m"

        Repetitions ->
            "times"

        Time Hours ->
            "h"

        Time Minutes ->
            "min"


renderMetric : Metric -> String
renderMetric { name, unit } =
    String.toLower
        (case unit of
            Km ->
                name ++ " in " ++ "km"

            Meter ->
                name ++ " in " ++ "meters"

            Repetitions ->
                name

            Time Hours ->
                name ++ " in " ++ "hours"

            Time Minutes ->
                name ++ " in " ++ "minutes"
        )


allSports : List Sport
allSports =
    [ Sport "Hiking" [ Metric "Distance" Km, Metric "Duration" (Time Hours), Metric "height" Meter ]
    , Sport "Running" [ Metric "Distance" Km ]
    , Sport "PullUps" [ Metric "Repetitions" Repetitions ]
    , Sport "PushUps" [ Metric "Repetitions" Repetitions ]
    , Sport "Boulder" [ Metric "Duration" (Time Hours) ]
    , Sport "Climbing" [ Metric "Duration" (Time Hours) ]
    ]
