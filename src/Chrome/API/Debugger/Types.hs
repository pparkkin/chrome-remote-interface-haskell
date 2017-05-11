{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE TemplateHaskell #-}

module Chrome.API.Debugger.Types where

import Data.Aeson
import Data.Aeson.TH

import Chrome.Target.Message.TH (deriveJSONMsg, escapeKeywords)
import Chrome.API.Runtime.Types (RemoteObject, ExceptionDetails, CallArgument)

data BreakpointActiveParam = BreakpointActiveParam
                             { active :: Bool }
                             deriving Show

$(deriveJSONMsg ''BreakpointActiveParam)

data SkipAllPausesParam = SkipAllPausesParam
                          { skip :: Bool }
                          deriving Show

$(deriveJSONMsg ''SkipAllPausesParam)

data BreakpointByURLParams = BreakpointByURLParams
                             { lineNumber :: Int
                             , url :: Maybe String
                             , urlRegex :: Maybe String
                             , columnNumber :: Maybe Int
                             , condition :: Maybe String
                             } deriving Show

$(deriveJSONMsg ''BreakpointByURLParams)

data Location = Location
                { scriptId :: String
                , lineNumber :: Int
                , columnNumber :: Maybe Int
                } deriving Show

$(deriveJSONMsg ''Location)

data BreakpointByURLResult = BreakpointByURLResult
                             { breakpointId :: String
                             , locations :: [Location]
                             } deriving Show

$(deriveJSONMsg ''BreakpointByURLResult)

data SetBreakpointParams = SetBreakpointParams
                           { location :: Location
                           , condition :: Maybe String
                           } deriving Show

$(deriveJSONMsg ''SetBreakpointParams)

data SetBreakpointResult = SetBreakpointResult
                           { breakpointId :: String
                           , actualLocation :: Location
                           } deriving Show

$(deriveJSONMsg ''SetBreakpointResult)

data RemoveBreakpointParams = RemoveBreakpointParams
                              { breakpointId :: String }
                              deriving Show

$(deriveJSONMsg ''RemoveBreakpointParams)

data ContinueToLocationParams = ContinueToLocationParams
                                { location :: Location }
                                deriving Show

$(deriveJSONMsg ''ContinueToLocationParams)

data SetScriptSourceParams = SetScriptSourceParams
                             { scriptId :: String
                             , scriptSource :: String
                             , dryRun :: Maybe Bool
                             } deriving Show

$(deriveJSONMsg ''SetScriptSourceParams)

data RestartFrameParams = RestartFrameParams
                          { callFrameId :: String }
                          deriving Show

$(deriveJSONMsg ''RestartFrameParams)

data GetScriptSourceParams = GetScriptSourceParams
                             { scriptId :: String }
                             deriving Show

$(deriveJSONMsg ''GetScriptSourceParams)

data GetScriptSourceResult = GetScriptSourceResult
                             { scriptSource :: String }
                             deriving Show

$(deriveJSONMsg ''GetScriptSourceResult)

data SetPauseOnExceptionsParams = SetPauseOnExceptionsParams
                                  { state :: String }
                                  deriving Show

$(deriveJSONMsg ''SetPauseOnExceptionsParams)

data EvaluateOnCallFrameParams = EvaluateOnCallFrameParams
                                 { callFrameId :: String
                                 , expression :: String
                                 , objectGroup :: Maybe String
                                 , includeCommandLineAPI :: Maybe Bool
                                 , silent :: Maybe Bool
                                 , returnByValue :: Maybe Bool
                                 , generatePreview :: Maybe Bool
                                 } deriving Show

$(deriveJSONMsg ''EvaluateOnCallFrameParams)

data EvaluateOnCallFrameResult = EvaluateOnCallFrameResult
                                 { result :: RemoteObject
                                 , exceptionDetails :: Maybe ExceptionDetails
                                 } deriving Show

$(deriveJSONMsg ''EvaluateOnCallFrameResult)

data SetVariableValueParams = SetVariableValueParams
                              { scopeNumber :: Int
                              , variableName :: String
                              , newValue :: CallArgument
                              , callFrameId :: String
                              } deriving Show

$(deriveJSONMsg ''SetVariableValueParams)

data SetAsyncCallStackDepthParams = SetAsyncCallStackDepthParams
                                    { maxDepth :: Int }
                                    deriving Show

$(deriveJSONMsg ''SetAsyncCallStackDepthParams)
