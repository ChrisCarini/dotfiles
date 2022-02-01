#!/usr/bin/env bash
if ! is-macos -o ; then
  echo "Skipped: Hammerspoon"
  return
fi

mkdir -p ~/.hammerspoon/Spoons/

pushd /tmp/

wget -O ShiftIt.spoon.zip https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/ShiftIt.spoon.zip

unzip /tmp/ShiftIt.spoon.zip

mv ShiftIt.spoon/ ~/.hammerspoon/Spoons/

rm /tmp/ShiftIt.spoon.zip

cat <<EOF > ~/.hammerspoon/init.lua
hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})
EOF

open /Applications/Hammerspoon.app

echo "You will need to enable Accessibility permissions for Hammerspoon.app now."

popd