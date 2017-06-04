module Msgs exposing (..)

import Http

type Msg 
    = PlayerId String
    | GameId String
    | RegisterGame
    | HandleResult (Result Http.Error String)