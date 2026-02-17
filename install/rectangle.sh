#!/usr/bin/env bash
if ! is-macos -o ; then
  echo "Skipped: Rectangle"
  return
fi

open /Applications/Rectangle.app

# https://github.com/rxhanson/Rectangle/blob/main/TerminalCommands.md#make-smallermake-larger-size-increments
defaults write com.knollsoft.Rectangle sizeOffset -float 150

# https://github.com/rxhanson/Rectangle/blob/main/TerminalCommands.md#make-smaller-limits
defaults write com.knollsoft.Rectangle minimumWindowWidth -float 0.1
defaults write com.knollsoft.Rectangle minimumWindowHeight -float 0.1

# https://github.com/rxhanson/Rectangle/blob/main/TerminalCommands.md#enable-todo-mode
defaults write com.knollsoft.Rectangle todo -int 1

echo "You will need to enable Accessibility permissions for Rectangle.app now."

popd