{-# LANGUAGE DeriveDataTypeable #-}
import Development.Shake
import Development.Shake.FilePath

-- |Track the uuid of an image, so we can rebuild our part of the chain if a FROM container outside of our project changes
trackImage :: FilePath -> String -> Action ()  
trackImage uuidFile image = do
        Stdout stdout <- cmd "docker images " [image] 
        let uuid = head $ words $ last $ lines stdout
        writeFileChanged uuidFile uuid

buildContainer :: FilePath -> String -> String -> Action ()
buildContainer uuidFile repository image = do
  () <- cmd "docker build -t " [imageName] [image]
  trackImage uuidFile imageName
  where imageName = repository </> image

main :: IO ()
main =
  shakeArgs shakeOptions{shakeFiles="_build/"} $ do
    want [ghcjsLibs]

    phony "clean" $ do
        putNormal "Cleaning files in _build"
        removeFilesAfter "_build" ["//*"]

    haskell %> \uuidFile -> do
        alwaysRerun
        trackImage uuidFile "haskell:7.8"

    ghcjsCabal *> \uuidFile -> do
        let image = dropExtension $ takeFileName uuidFile
        need [haskell, image </> dockerfile]
        buildContainer uuidFile repository image

    ghcjsBoot *> \uuidFile -> do
        let image = dropExtension $ takeFileName uuidFile
        need [ghcjsCabal, image </> dockerfile]
        buildContainer uuidFile repository image
    ghcjsLibs *> \uuidFile -> do
        let image = dropExtension $ takeFileName uuidFile
        need [ghcjsCabal, image </> dockerfile]
        buildContainer uuidFile repository image
    where
      haskell = images </> "haskell-7.8.uuid"
      ghcjsCabal = images </> "ghcjs-cabal.uuid"
      ghcjsBoot = images </> "ghcjs-boot.uuid"
      ghcjsLibs = images </> "ghcjs-libs.uuid"
      dockerfile = "Dockerfile"
      repository = "atddio"
      images = "images"
