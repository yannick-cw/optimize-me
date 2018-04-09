module Main exposing (..)

import Navigation exposing (Location, modifyUrl, newUrl)
import Routing exposing (Route(..), parseLocation)
import View exposing (view)
import Model exposing (Model, Msg(..))
import Html.Styled exposing (toUnstyled)
import Sports exposing (allSports, TrackedSport)
import Dict exposing (Dict)


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = locationUpdate (Model Track allSports [] Dict.empty)
        , view = view >> toUnstyled
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange l ->
            locationUpdate { model | currentInputs = Dict.empty } l

        ClickSport s ->
            ( model, newUrl <| "/track/" ++ (String.toLower s.name) )

        AddTrackingEntry s ->
            let
                newEntry =
                    TrackedSport s (Dict.values model.currentInputs)
            in
                ( { model | trackedSports = newEntry :: model.trackedSports, currentInputs = Dict.empty }, Cmd.none )

        UpdateSportInputs metric value ->
            let
                newDict =
                    Dict.insert metric.name ( metric, value ) model.currentInputs
            in
                ( { model | currentInputs = newDict }, Cmd.none )

        NavigateTo url ->
            ( model, newUrl url )


locationUpdate : Model -> Location -> ( Model, Cmd Msg )
locationUpdate model location =
    let
        currentRoute =
            parseLocation model.sports location
    in
        case currentRoute of
            Home ->
                ( { model | currentRoute = currentRoute }, modifyUrl "track" )

            _ ->
                ( { model | currentRoute = currentRoute }, Cmd.none )
