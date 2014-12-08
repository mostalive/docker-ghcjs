{-# LANGUAGE DeriveDataTypeable #-}
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util
import Data.Set
import Data.List as L
import Data.Typeable
import GHC.IO.Exception

-- |Track the uuid of an image, so we can rebuild our part of the chain if a FROM container outside of our project changes
trackImage :: FilePath -> String -> Action ()  
trackImage uuidFile image = do
        Stdout stdout <- cmd "docker images " [image] 
        let uuid = head $ words $ last $ lines stdout
        writeFileChanged uuidFile uuid

buildContainer :: FilePath -> String -> FilePath -> Action ()
buildContainer uuidFile imageName dockerFilePath = do
  () <- cmd "docker build -t " [imageName] [dockerFilePath]
  trackImage uuidFile imageName

main :: IO ()
main =
  shakeArgs shakeOptions{shakeFiles="_build/"} $ do
    want ["images/ghcjs-cabal.uuid","images/ghcjs-boot.uuid"]

    phony "clean" $ do
        putNormal "Cleaning files in _build"
        removeFilesAfter "_build" ["//*"]

    "images/haskell-7.8.uuid" %> \out -> do
        alwaysRerun
        trackImage out "haskell:7.8"
    
    "images/ghcjs-cabal.uuid" *> \uuidFile -> do
        need ["images/haskell-7.8.uuid","ghcjs-cabal/Dockerfile"]
        buildContainer uuidFile "atddio/ghcjs-cabal" "ghcjs-cabal" 
 
    "images/ghcjs-boot.uuid" *> \uuidFile -> do
        need ["images/ghcjs-cabal.uuid", "ghcjs-boot/Dockerfile"]
        buildContainer uuidFile "atddio/ghcjs-boot" "ghcjs-boot"
