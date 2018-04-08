module Main exposing (..)

import Navigation exposing (Location)
import Routing exposing (Route(..), parseLocation)
import View exposing (view)
import Model exposing (Model, Msg(..))


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = locationUpdate (Model Track)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange l ->
            locationUpdate model l


locationUpdate : Model -> Location -> ( Model, Cmd Msg )
locationUpdate model location =
    ( { model | currentRoute = parseLocation location }, Cmd.none )
