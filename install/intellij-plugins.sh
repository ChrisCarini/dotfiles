#!/usr/bin/env bash
####
# PERSONAL INTELLIJ PLUGINS - IntelliJ Community & Ultimate
####

if ! is-macos -o ! is-executable wget -o ! is-executable unzip; then
  echo "Skipped: IntelliJ Plugins"
  return
fi

# Install plugins
plugins=(
  # My Plugins
  11941 # `Automatic Power Saver` - https://plugins.jetbrains.com/plugin/11941-automatic-power-saver
  10998 # `Environment Variable Settings Summary` - https://plugins.jetbrains.com/plugin/10998-environment-variable-settings-summary
  11195 # `Logshipper` - https://plugins.jetbrains.com/plugin/11195-logshipper
  10924 # `sample-notification` - https://plugins.jetbrains.com/plugin/10924-sample-notification

  # Other Plugins
  17718 # `GitHub Copilot - https://plugins.jetbrains.com/plugin/17718-github-copilot
  7499  # `GitToolBox` - https://plugins.jetbrains.com/plugin/7499-gittoolbox
  12175 # `Grazie` - https://plugins.jetbrains.com/plugin/12175-grazie
  9746  # `Ideolog` - https://plugins.jetbrains.com/plugin/9746-ideolog
  7345  # `Presentation Assistant` - https://plugins.jetbrains.com/plugin/7345-presentation-assistant
  6610  # `PHP` - https://plugins.jetbrains.com/plugin/6610-php
  7322  # `Python (IC)` - https://plugins.jetbrains.com/plugin/7322-python-community-edition
  17035 # `Resource Bundle Editor` - https://plugins.jetbrains.com/plugin/17035-resource-bundle-editor
  10080 # `Rainbow Brackets` - https://plugins.jetbrains.com/plugin/10080-rainbow-brackets
  13308 # `Indent Rainbow` - https://plugins.jetbrains.com/plugin/13308-indent-rainbow
  12494 # `Big Data Tools` - https://plugins.jetbrains.com/plugin/12494-big-data-tools
  1347  # `Scala` - https://plugins.jetbrains.com/plugin/1347-scala
  14494 # `PDF Viewer` - https://plugins.jetbrains.com/plugin/14494-pdf-viewer
)

for PLUGIN in "${plugins[@]}"; do
  echo "============================="
  echo "Installing [$PLUGIN] ..."

  wget -O "/tmp/IJ_PLUGIN-$PLUGIN.zip" https://plugins.jetbrains.com/files/$(curl "https://plugins.jetbrains.com/api/plugins/$PLUGIN/updates" | jq -r '.[0].file')
  # Ref: https://intellij-support.jetbrains.com/hc/en-us/articles/206544519
  for install_dir in ~/Library/Application\ Support/JetBrains/{IdeaIC,IntelliJIdea}20*/plugins/ ; do
    unzip "/tmp/IJ_PLUGIN-$PLUGIN.zip" -d "$install_dir"
  done
  rm "/tmp/IJ_PLUGIN-$PLUGIN.zip"
done
