#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

### Install Dependencies
apt -qq -yy install devscripts lintian build-essential automake autotools-dev
mk-build-deps -i -t "apt-get --yes" -r

### Hack for debuild
mkdir -p $SCRIPTPATH/source
mv $SCRIPTPATH/../* $SCRIPTPATH/source/

### Build Deb
pushd $SCRIPTPATH/source
    debuild -b -uc -us
popd

ls -al $SCRIPTPATH/source
ls -al $SCRIPTPATH/
