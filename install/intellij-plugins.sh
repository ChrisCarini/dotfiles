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
  19543 # `Automatic GitHub Issue Navigation Configuration` - https://plugins.jetbrains.com/plugin/19543-automatic-github-issue-navigation-configuration
  11941 # `Automatic Power Saver` - https://plugins.jetbrains.com/plugin/11941-automatic-power-saver
  10998 # `Environment Variable Settings Summary` - https://plugins.jetbrains.com/plugin/10998-environment-variable-settings-summary
  19508 # `Git Push Reminder` - https://plugins.jetbrains.com/plugin/19508-git-push-reminder
  18137 # `Iris` - https://plugins.jetbrains.com/plugin/18137-iris
  19113 # `Lines of Code Change Observer` - https://plugins.jetbrains.com/plugin/19113-lines-of-code-change-observer
  11195 # `Logshipper` - https://plugins.jetbrains.com/plugin/11195-logshipper
  18126 # `sample-menu-action` - https://plugins.jetbrains.com/plugin/18126-sample-menu-action
  10924 # `sample-notification` - https://plugins.jetbrains.com/plugin/10924-sample-notification

  # Other Plugins
  6834  # `Apache config (.htaccess)` - https://plugins.jetbrains.com/plugin/6834-apache-config--htaccess-
  12494 # `Big Data Tools` - https://plugins.jetbrains.com/plugin/12494-big-data-tools
  8393  # `Code::Stats` - https://plugins.jetbrains.com/plugin/8393-code-stats
  14823 # `Full Line Code Completion` - https://plugins.jetbrains.com/plugin/14823-full-line-code-completion
  17718 # `GitHub Copilot - https://plugins.jetbrains.com/plugin/17718-github-copilot
  7499  # `GitToolBox` - https://plugins.jetbrains.com/plugin/7499-gittoolbox
  9568  # `Go` - https://plugins.jetbrains.com/plugin/9568-go
  8097  # `GraphQL` - https://plugins.jetbrains.com/plugin/8097-graphql
  12175 # `Grazie` - https://plugins.jetbrains.com/plugin/12175-grazie
  6884  # `Handlebars / Mustache` - https://plugins.jetbrains.com/plugin/6884-handlebars-mustache
  9746  # `Ideolog` - https://plugins.jetbrains.com/plugin/9746-ideolog
  13308 # `Indent Rainbow` - https://plugins.jetbrains.com/plugin/13308-indent-rainbow
  6981  # `Ini` - https://plugins.jetbrains.com/plugin/6981-ini
  6954  # `Kotlin` - https://plugins.jetbrains.com/plugin/6954-kotlin
  9333  # `Makefile Language` - https://plugins.jetbrains.com/plugin/9333-makefile-language
  14494 # `PDF Viewer` - https://plugins.jetbrains.com/plugin/14494-pdf-viewer
  6610  # `PHP` - https://plugins.jetbrains.com/plugin/6610-php
  18568 # `Polaris` - https://plugins.jetbrains.com/plugin/18568-polaris
  7345  # `Presentation Assistant` - https://plugins.jetbrains.com/plugin/7345-presentation-assistant
  7322  # `Python (IC)` - https://plugins.jetbrains.com/plugin/7322-python-community-edition
  631   # `Python (IU)` - https://plugins.jetbrains.com/plugin/631-python
  10080 # `Rainbow Brackets` - https://plugins.jetbrains.com/plugin/10080-rainbow-brackets
  10837 # `Requirements` - https://plugins.jetbrains.com/plugin/10837-requirements
  17035 # `Resource Bundle Editor` - https://plugins.jetbrains.com/plugin/17035-resource-bundle-editor
  1347  # `Scala` - https://plugins.jetbrains.com/plugin/1347-scala
  2162  # `String Manipulation` - https://plugins.jetbrains.com/plugin/2162-string-manipulation
  7425  # `WakaTime` - https://plugins.jetbrains.com/plugin/7425-wakatime
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
