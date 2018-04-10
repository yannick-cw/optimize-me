module Routing exposing (Route(..), parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (map, top, Parser, parsePath, oneOf, s, (</>), (<?>), stringParam, string)
import Sports exposing (Sport)


type Route
    = Home
    | Track
    | TrackSport Sport
    | Authenticated String
    | NotFoundRoute


type alias ValidSports =
    List Sport


matchers : ValidSports -> Parser (Route -> a) a
matchers validSports =
    oneOf
        [ map Home top
        , map Track (s "track")
        , map maybeAuth (s "oauthcallback" <?> stringParam "access_token")
        , map (checkIfSport validSports) (s "track" </> string)
        ]


maybeAuth : Maybe String -> Route
maybeAuth maybeToken =
    case maybeToken of
        Just tk ->
            Authenticated tk

        Nothing ->
            NotFoundRoute


checkIfSport : ValidSports -> String -> Route
checkIfSport validSports sport =
    validSports
        |> List.filter (\s -> (String.toLower s.name) == (String.toLower sport))
        |> List.head
        |> Maybe.map TrackSport
        |> Maybe.withDefault NotFoundRoute


parseLocation : ValidSports -> Location -> Route
parseLocation validSports location =
    case (parsePath (matchers validSports) { location | search = location.hash }) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
