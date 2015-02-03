#!/bin/sh
set -v
set -x
set -e
export TARGETUSER=curry
export ORIGPASSWD=$(cat /etc/passwd | grep TARGETUSER)
export ORIG_UID=`id -u curry`
export ORIG_GID=`id -g curry`

export DEV_UID=${DEV_UID:=$ORIG_UID}
export DEV_GID=${DEV_GID:=$ORIG_GID}

echo $DEV_UID
echo $DEV_GID

ORIG_HOME=/home/$TARGETUSER

echo $ORIG_HOME

sed -i -e "s/:$ORIG_UID:$ORIG_GID:/:$DEV_UID:$DEV_GID:/" /etc/passwd
sed -i -e "s/$TARGETUSER:x:$ORIG_GID:/$TARGETUSER:x:$DEV_GID:/" /etc/group

chown -R ${DEV_UID}.${DEV_GID} ${ORIG_HOME}

groupmod -g $DOCKER_GID docker

echo '127.0.0.1 app' >> /etc/hosts

# fix path to access home built ghc
echo "export PATH=/opt/ghc/7.8.3/bin:/opt/cabal/1.20/bin:\$PATH" >> /home/curry/.bash_profile
chown $DEV_UID:$DEV_GID /home/curry/.bash_profile

exec su -l - curry
