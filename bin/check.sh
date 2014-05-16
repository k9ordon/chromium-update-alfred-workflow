#!/bin/bash

LATEST=`curl -s http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE`
CURRENT=`defaults read /Applications/Chromium.app/Contents/Info.plist SCMRevision 2>/dev/null`

osascript -e 'display notification "Current: '$CURRENT' Latest: '$LATEST'" with title "Chromium Update"'
