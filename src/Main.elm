module Main exposing (..)

import Navigation exposing (Location, modifyUrl, newUrl)
import Routing exposing (Route(..), parseLocation)
import View exposing (view)
import Model exposing (Model(..), Msg(..), LoggedInModel)
import Html.Styled exposing (toUnstyled)
import Sports exposing (allSports, TrackedSport)
import Dict exposing (Dict)
import Date exposing (Date)
import Time exposing (Time, second, millisecond)
import Task exposing (Task)
import GoogleAuth exposing (loadToken, getUserId)


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = locationUpdate NotLoggedIn
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (5 * second) Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        NotLoggedIn ->
            case msg of
                User (Ok id) ->
                    ( LoggedIn (LoggedInModel id Track Nothing allSports [] Dict.empty), newUrl "/track" )

                OnLocationChange l ->
                    locationUpdate model l

                _ ->
                    ( model, Cmd.none )

        LoggedIn m ->
            let
                ( loggedInM, cmd ) =
                    (updateLoggedIn msg m)
            in
                ( LoggedIn loggedInM, cmd )


updateLoggedIn : Msg -> LoggedInModel -> ( LoggedInModel, Cmd Msg )
updateLoggedIn msg model =
    case msg of
        OnLocationChange l ->
            loggedInUpdate { model | currentInputs = Dict.empty } l

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

        Tick time ->
            ( { model | currentDate = Just <| Date.fromTime time }, Cmd.none )

        NavigateTo url ->
            ( model, newUrl url )

        _ ->
            ( model, Cmd.none )


locationUpdate : Model -> Location -> ( Model, Cmd Msg )
locationUpdate model location =
    case model of
        NotLoggedIn ->
            let
                currentRoute =
                    parseLocation [] location
            in
                case currentRoute of
                    Authenticated tk ->
                        ( model, getUserId tk )

                    Home ->
                        ( model, loadToken ("http://" ++ location.host ++ "/oauthcallback") )

                    Track ->
                        ( model, loadToken ("http://" ++ location.host ++ "/oauthcallback") )

                    _ ->
                        ( model, Cmd.none )

        LoggedIn m ->
            let
                ( newModel, cmd ) =
                    loggedInUpdate m location
            in
                ( LoggedIn newModel, cmd )


loggedInUpdate : LoggedInModel -> Location -> ( LoggedInModel, Cmd Msg )
loggedInUpdate model location =
    let
        currentRoute =
            parseLocation model.sports location
    in
        case currentRoute of
            Home ->
                ( { model | currentRoute = currentRoute }, modifyUrl "track" )

            _ ->
                ( { model | currentRoute = currentRoute }, Task.perform Tick Time.now )
