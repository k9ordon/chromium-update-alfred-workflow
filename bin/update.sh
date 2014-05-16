#!/bin/bash

LATEST=`curl -s http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE`
CURRENT=`defaults read /Applications/Chromium.app/Contents/Info.plist SCMRevision 2>/dev/null`
PROCESSID=`ps ux | awk '/Chromium/ && !/awk/ {print $2}'`

# check revision
if [ $LATEST -lt 1 ]; then
  osascript -e 'display notification "Cannot find repository" with title "Chromium Update"'
  exit 0
fi
if [[ $LATEST -eq $CURRENT ]]; then
  osascript -e 'display notification "Already up to date - '$LATEST'" with title "Chromium Update"'
  exit 0
fi

# download
osascript -e 'display notification "Downloading '$LATEST' ..." with title "Chromium Update"'
curl -L "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/$LATEST/chrome-mac.zip" -o /tmp/chrome-mac.zip
wait

# unzip, kill, move, rm tmp, open
osascript -e 'display notification "Installing '$LATEST' ..." with title "Chromium Update"'
unzip -o -qq /tmp/chrome-mac.zip -d /tmp
wait
for x in $PROCESSID; do
  kill -9 $x
done
rm -Rf /Applications/Chromium.app
wait
cp -R /tmp/chrome-mac/Chromium.app /Applications
wait
rm -rf /tmp/chrome-*
wait
open -Rf /Applications/Chromium.app

# done
osascript -e 'display notification "Updated to '$LATEST'" with title "Chromium Update"'
exit 0
