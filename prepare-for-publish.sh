#!/bin/sh
# This script is used to prepare the project for publishing.

BUILD_DIR=build
VARIANT=unchained

FIREFOX_VERSION=$(cat "$BUILD_DIR/FIREFOX_VERSION.txt")
GECKODRIVER_VERSION=$(cat "$BUILD_DIR/GECKODRIVER_VERSION.txt")

mv "$BUILD_DIR/bin/geckodriver-$VARIANT-win.exe" "$BUILD_DIR/bin/geckodriver-$VARIANT-win-$GECKODRIVER_VERSION-ff-$FIREFOX_VERSION.exe"
mv "$BUILD_DIR/bin/geckodriver-$VARIANT-intel-mac" "$BUILD_DIR/bin/geckodriver-$VARIANT-intel-mac-$GECKODRIVER_VERSION-ff-$FIREFOX_VERSION"
mv "$BUILD_DIR/bin/geckodriver-$VARIANT-arm-mac" "$BUILD_DIR/bin/geckodriver-$VARIANT-arm-mac-$GECKODRIVER_VERSION-ff-$FIREFOX_VERSION"
mv "$BUILD_DIR/bin/geckodriver-$VARIANT-linux" "$BUILD_DIR/bin/geckodriver-$VARIANT-linux-$GECKODRIVER_VERSION-ff-$FIREFOX_VERSION"

cd "$BUILD_DIR/bin"
sha256sum * > SHA256SUMS.txt
cd ../..
