{-# LANGUAGE OverloadedStrings #-}

module Chrome.API.Page.Types where

import Data.Aeson

data PageReloadParams = PageReloadParams
                        {
                          _pIgnoreCache :: Bool
                        , _pScriptToEvaluateOnLoad :: Maybe String
                        } deriving Show

instance ToJSON PageReloadParams where
  toJSON (PageReloadParams ignoreCache script) = object [ "ignoreCache" .= ignoreCache
                                                        , "scriptToEvaluateOnLoad" .= script
                                                        ]

data PageHandleDialogParams = PageHandleDialogParams
                              {
                                _pAccept :: Bool
                              , _pPromptText :: Maybe String
                              } deriving Show

instance ToJSON PageHandleDialogParams where
  toJSON (PageHandleDialogParams accept promptText) = object [ "accept" .= accept
                                                             , "promptText" .= promptText
                                                             ]

newtype FrameId = FrameId String
                  deriving Show

instance FromJSON FrameId where
  parseJSON = withObject "frame" $ \o -> FrameId <$> o .: "frameId"

data CaptureScreenshotParams = CaptureScreenshotParams
                                {
                                  _pScreenshotFormat :: String
                                , _pScreenshotQuality :: Int
                                , _pScreenshotFromSurface :: Bool
                                } deriving Show

instance ToJSON CaptureScreenshotParams where
    toJSON (CaptureScreenshotParams format quality fromSurface) = object [ "format" .= format
                                                                         , "quality" .= quality
                                                                         , "fromSurface" .= fromSurface
                                                                         ]

data CaptureScreenshotResult = CaptureScreenshotResult
                                {
                                  _screenshotData :: String
                                } deriving Show

instance FromJSON CaptureScreenshotResult where
    parseJSON = withObject "screenshot" $ \o -> CaptureScreenshotResult <$> o .: "data"

newtype TimestampEvent = TimestampEvent Int
                         deriving Show

instance FromJSON TimestampEvent where
  parseJSON = withObject "timestamp" $ \o -> TimestampEvent <$> o .: "timestamp"

data FrameAttachedEvent = FrameAttachedEvent
                          {
                            _eventFrameId :: String
                          , _eventParentFrameId :: String
                          } deriving Show

instance FromJSON FrameAttachedEvent where
  parseJSON = withObject "params" $ \o -> FrameAttachedEvent
                                          <$> o .: "frameId"
                                          <*> o .: "parentFrameId"

data Frame = Frame
             {
               _frameId :: String
             , _frameParentId :: Maybe String
             , _frameLoaderId :: String
             , _frameName :: Maybe String
             , _frameUrl :: String
             , _frameSecurityOrigin :: String
             , _frameMimeType :: String
             } deriving Show

instance FromJSON Frame where
  parseJSON = withObject "frame" $ \o -> Frame
                                         <$> o .: "id"
                                         <*> o .:? "parentId"
                                         <*> o .: "loaderId"
                                         <*> o .:? "name"
                                         <*> o .: "url"
                                         <*> o .: "securityOrigin"
                                         <*> o .: "mimeType"

type DialogType = String

data DialogOpeningEvent = DialogOpeningEvent
                          {
                            _dialogText :: String
                          , _dialogType :: DialogType
                          } deriving Show

instance FromJSON DialogOpeningEvent where
  parseJSON = withObject "dialog" $ \o -> DialogOpeningEvent
                                          <$> o .: "message"
                                          <*> o .: "type"

newtype DialogClosingEvent = DialogClosingEvent Bool
                             deriving Show

instance FromJSON DialogClosingEvent where
  parseJSON = withObject "param" $ \o -> DialogClosingEvent <$> o .: "result"

data NavigationRequestEvent = NavigationRequestEvent
                              {
                                _navIsInMainFrame :: Bool
                              , _navIsRedirect :: Bool
                              , _navNavigationId :: Int
                              , _navUrl :: String
                              } deriving Show

instance FromJSON NavigationRequestEvent where
  parseJSON = withObject "navigation" $ \o -> NavigationRequestEvent
                                              <$> o .: "isInMainFrame"
                                              <*> o .: "isRedirect"
                                              <*> o .: "navigationId"
                                              <*> o .: "url"

