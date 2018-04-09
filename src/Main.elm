module Main exposing (..)

import Navigation exposing (Location, modifyUrl)
import Routing exposing (Route(..), parseLocation)
import View exposing (view)
import Model exposing (Model, Msg(..), allSports)
import Html.Styled exposing (toUnstyled)


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = locationUpdate (Model Track allSports)
        , view = view >> toUnstyled
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange l ->
            locationUpdate model l

        ClickSport s ->
            ( model, modifyUrl <| "track/" ++ (String.toLower s) )


locationUpdate : Model -> Location -> ( Model, Cmd Msg )
locationUpdate model location =
    let
        currentRoute =
            parseLocation location
    in
        case currentRoute of
            Home ->
                ( { model | currentRoute = currentRoute }, modifyUrl "track" )

            TrackSport sport ->
                if (allSports |> List.any (\s -> (String.toLower s) == (String.toLower sport))) then
                    ( { model | currentRoute = currentRoute }, Cmd.none )
                else
                    ( { model | currentRoute = NotFoundRoute }, Cmd.none )

            _ ->
                ( { model | currentRoute = currentRoute }, Cmd.none )
