#!/bin/sh

trap 'exit 0' INT
echo "Checking for an existing installation of fastlane. This may take a moment..."
# check to see if fastlane is already installed
FASTLANE_PATH=`which fastlane`
VERSION=`$FASTLANE_PATH -v 2>/dev/null`
if [ $? == 0 ]; then
    echo "An installation of fastlane was found at this path: $FASTLANE_PATH"
    echo "Congratulations, it looks like fastlane is already installed! Check out https://fastlane.tools or the Fabric Mac app for quick tips on how to get started 🚀"
    `open "fabric://install-fastlane?INSTALL_PATH=$FASTLANE_PATH"`
    exit 0
else
    echo "No previous installation found. Now installing fastlane via the Fabric Mac app 🚀"
    `open "fabric://install-fastlane"`
    exit 0
fi