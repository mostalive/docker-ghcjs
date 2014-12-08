{-# LANGUAGE DeriveDataTypeable #-}
import Development.Shake
import Development.Shake.FilePath

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
    want ["images" </> "ghcjs-cabal.uuid", "images" </> "ghcjs-boot.uuid"]

    phony "clean" $ do
        putNormal "Cleaning files in _build"
        removeFilesAfter "_build" ["//*"]

    haskellUuid %> \uuidFile -> do
        alwaysRerun
        trackImage uuidFile "haskell:7.8"

    images </> "ghcjs-cabal.uuid" *> \uuidFile -> do
        let image = dropExtension $ takeFileName uuidFile
        need [haskellUuid, image </> dockerfile]
        buildContainer uuidFile (repository </> image) image

    images </> "ghcjs-boot.uuid" *> \uuidFile -> do
        let image = dropExtension $ takeFileName uuidFile
        need [ghcjsUuid, image </> dockerfile]
        buildContainer uuidFile (repository </> image) image
    where
      haskellUuid = "images" </> "haskell-7.8.uuid"
      ghcjsUuid = "images" </> "ghcjs-cabal.uuid"
      dockerfile = "Dockerfile"
      repository = "atddio"
      images = "images"
