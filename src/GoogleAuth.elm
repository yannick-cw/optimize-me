module GoogleAuth exposing (loadToken, getUserId)

import Navigation exposing (load)
import Model exposing (Msg(..))
import Http
import Json.Decode
import Json.Decode.Pipeline


loadToken : String -> Cmd msg
loadToken redirectHref =
    load
        ("https://accounts.google.com/o/oauth2/v2/auth?"
            ++ "scope=openid profile&"
            ++ "redirect_uri="
            ++ Http.encodeUri redirectHref
            ++ "&response_type=token&"
            ++ "client_id=872902010339-v5vhv6cton27uuaqfcu56ahahg5ff9um.apps.googleusercontent.com"
        )


getUserId : String -> Cmd Msg
getUserId token =
    Http.get ("https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=" ++ token) decodeUserResp
        |> Http.send User


type alias UserRes =
    { sub : String }


decodeUserResp : Json.Decode.Decoder String
decodeUserResp =
    Json.Decode.Pipeline.decode UserRes
        |> Json.Decode.Pipeline.required "sub" Json.Decode.string
        |> Json.Decode.map .sub
