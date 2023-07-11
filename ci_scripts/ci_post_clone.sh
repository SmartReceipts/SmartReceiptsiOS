#!/bin/sh

if [ $CI_XCODEBUILD_ACTION = 'archive' ]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"   

    brew install gnupg

    echo $GPG_SECRET | base64 --decode | gpg --import
    gpg -d ../secrets.tar.gpg | tar xv || true
else
    echo "Nothing to do for this action"
fi