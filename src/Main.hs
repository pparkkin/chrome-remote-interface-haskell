{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.HTTP.Client (newManager, httpLbs, defaultManagerSettings, responseBody)
import Data.Aeson
import Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as B8

import qualified Data.Text.IO as T
import Data.Maybe
import Data.Map as M

import Network.Socket (withSocketsDo)
import qualified Network.WebSockets as WS
import Network.URL

import Control.Concurrent (forkIO)
import Control.Concurrent.Async (async, wait)
import Control.Monad (forever, unless)

import Control.Monad.Trans
import Control.Monad.Trans.Reader

import Chrome.DebuggingURL
import Chrome.InspectablePage
import Chrome.DebuggingMessage
import Chrome.WSClient
import Chrome.API.Page (navigate)
import Chrome.API.DOM (
  getDocument
  , GetDocumentResponse(..)
  , querySelector
  , Node(..)
  , QuerySelectorResponse
  , querySelectorAll
  , QuerySelectorAllResponse
  )

head' :: [a] -> Maybe a
head' (x:_) = Just x
head' _ = Nothing

sampleCommands :: WSChannelsT ()
sampleCommands = do
  sendCmd' $ navigate "http://github.com" :: WSChannelsT (Maybe Value)
  doc <- sendCmd' getDocument :: WSChannelsT (Maybe GetDocumentResponse)
  liftIO $ print doc

  case doc of
    Nothing -> liftIO $ putStrLn "No document found :/"
    Just doc' -> do
      nodes <- sendCmd' $ querySelectorAll (nodeId . root $ doc') "a" :: WSChannelsT (Maybe QuerySelectorAllResponse)
      liftIO $ print nodes

  return ()

main :: IO ()
main = do
  pages <- fetchInspectablePages
  let firstPage = head' =<< pages
  case firstPage of
    Nothing -> putStrLn "No page found"
    Just p -> do
      onPage' p sampleCommands
