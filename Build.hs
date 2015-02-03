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
  () <- cmd "docker build --no-cache -t " [imageName] [image]
  trackImage uuidFile imageName
  where imageName = repository </> image

main :: IO ()
main =
  shakeArgs shakeOptions{shakeFiles="_build/"} $ do
    want [ghcjsDevenv]

    phony "clean" $ do
        putNormal "Cleaning files in _build"
        removeFilesAfter "_build" ["//*"]

    haskell %> \uuidFile -> do
        alwaysRerun
        () <- cmd ["docker", "pull", haskellImage]
        trackImage uuidFile haskellImage

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
        need [ghcjsBoot, image </> dockerfile]
        buildContainer uuidFile repository image

    ghcjsDevenv *> \uuidFile -> do
        let image = dropExtension $ takeFileName uuidFile
        need [ghcjsLibs, image </> dockerfile]
        buildContainer uuidFile repository image

    ghcjsEmacs *> \uuidFile -> do
        let image = dropExtension $ takeFileName uuidFile
        need [ghcjsLibs, image </> dockerfile]
        buildContainer uuidFile repository image
    
    where
      haskell = images </> "haskell-7.8.uuid"
      haskellImage = "haskell:7.8"
      ghcjsCabal = images </> "ghcjs-cabal.uuid"
      ghcjsBoot = images </> "ghcjs-boot.uuid"
      ghcjsLibs = images </> "ghcjs-libs.uuid"
      ghcjsDevenv = images </> "ghcjs-sample-devenv.uuid"
      ghcjsEmacs = images </> "ghcjs-emacs.uuid"
      dockerfile = "Dockerfile"
      repository = "atddio"
      images = "images"
