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
  com.chriscarini.jetbrains.automatic-github-issue-navigation-configuration-jetbrains-plugin # `Automatic GitHub Issue Navigation Configuration` - https://plugins.jetbrains.com/plugin/19543-automatic-github-issue-navigation-configuration
  com.chriscarini.jetbrains.jetbrains-auto-power-saver                                       # `Automatic Power Saver` - https://plugins.jetbrains.com/plugin/11941-automatic-power-saver
  com.chriscarini.jetbrains.environment-variable-settings-summary                            # `Environment Variable Settings Summary` - https://plugins.jetbrains.com/plugin/10998-environment-variable-settings-summary
  com.chriscarini.jetbrains.git-push-reminder-jetbrains-plugin                               # `Git Push Reminder` - https://plugins.jetbrains.com/plugin/19508-git-push-reminder
  com.chriscarini.jetbrains.iris-jetbrains-plugin                                            # `Iris` - https://plugins.jetbrains.com/plugin/18137-iris
  com.chriscarini.jetbrains.loc-change-count-detector-jetbrains-plugin                       # `Lines of Code Change Observer` - https://plugins.jetbrains.com/plugin/19113-lines-of-code-change-observer
  com.chriscarini.jetbrains.logshipper                                                       # `Logshipper` - https://plugins.jetbrains.com/plugin/11195-logshipper
  com.chriscarini.jetbrains.sample-intellij-plugin                                           # `sample-menu-action` - https://plugins.jetbrains.com/plugin/18126-sample-menu-action
  com.chriscarini.jetbrains.intellij-sample-notification                                     # `sample-notification` - https://plugins.jetbrains.com/plugin/10924-sample-notification

  # Other Plugins
  com.intellij.apacheConfig                                      # `Apache config (.htaccess)` - https://plugins.jetbrains.com/plugin/6834-apache-config--htaccess-
  com.intellij.bigdatatools                                      # `Big Data Tools` - https://plugins.jetbrains.com/plugin/12494-big-data-tools
  net.codestats.plugin.atom.intellij                             # `Code::Stats` - https://plugins.jetbrains.com/plugin/8393-code-stats
  org.jetbrains.completion.full.line                             # `Full Line Code Completion` - https://plugins.jetbrains.com/plugin/14823-full-line-code-completion
  com.github.copilot                                             # `GitHub Copilot - https://plugins.jetbrains.com/plugin/17718-github-copilot
  zielu.gittoolbox                                               # `GitToolBox` - https://plugins.jetbrains.com/plugin/7499-gittoolbox
  org.jetbrains.plugins.go                                       # `Go` - https://plugins.jetbrains.com/plugin/9568-go
  com.intellij.lang.jsgraphql                                    # `GraphQL` - https://plugins.jetbrains.com/plugin/8097-graphql
  tanvd.grazi                                                    # `Grazie` - https://plugins.jetbrains.com/plugin/12175-grazie
  com.dmarcotte.handlebars                                       # `Handlebars / Mustache` - https://plugins.jetbrains.com/plugin/6884-handlebars-mustache
  com.intellij.ideolog                                           # `Ideolog` - https://plugins.jetbrains.com/plugin/9746-ideolog
  indent-rainbow.indent-rainbow                                  # `Indent Rainbow` - https://plugins.jetbrains.com/plugin/13308-indent-rainbow
  com.jetbrains.plugins.ini4idea                                 # `Ini` - https://plugins.jetbrains.com/plugin/6981-ini
  org.jetbrains.kotlin                                           # `Kotlin` - https://plugins.jetbrains.com/plugin/6954-kotlin
  name.kropp.intellij.makefile                                   # `Makefile Language` - https://plugins.jetbrains.com/plugin/9333-makefile-language
  com.intellij.mermaid                                           # `Mermaid` - https://plugins.jetbrains.com/plugin/20146-mermaid
  com.firsttimeinforever.intellij.pdf.viewer.intellij-pdf-viewer # `PDF Viewer` - https://plugins.jetbrains.com/plugin/14494-pdf-viewer
  com.jetbrains.php                                              # `PHP` - https://plugins.jetbrains.com/plugin/6610-php
  com.jetbrains.intellij.code.search.polaris                     # `Polaris` - https://plugins.jetbrains.com/plugin/18568-polaris
  org.nik.presentation-assistant                                 # `Presentation Assistant` - https://plugins.jetbrains.com/plugin/7345-presentation-assistant
  izhangzhihao.rainbow.brackets                                  # `Rainbow Brackets` - https://plugins.jetbrains.com/plugin/10080-rainbow-brackets
  ru.meanmail.plugin.requirements                                # `Requirements` - https://plugins.jetbrains.com/plugin/10837-requirements
  com.intellij.properties.bundle.editor                          # `Resource Bundle Editor` - https://plugins.jetbrains.com/plugin/17035-resource-bundle-editor
  org.intellij.scala                                             # `Scala` - https://plugins.jetbrains.com/plugin/1347-scala
  String Manipulation                                            # `String Manipulation` - https://plugins.jetbrains.com/plugin/2162-string-manipulation
  com.wakatime.intellij.plugin                                   # `WakaTime` - https://plugins.jetbrains.com/plugin/7425-wakatime
)

# Install Python plugins for both CE and IU
open -Wa "IntelliJ IDEA CE.app" --args installPlugins "PythonCore" # `Python (IC)` - https://plugins.jetbrains.com/plugin/7322-python-community-edition
open -Wa "IntelliJ IDEA.app" --args installPlugins "Pythonid"      # `Python (IU)` - https://plugins.jetbrains.com/plugin/631-python

for PLUGIN in "${plugins[@]}"; do
  echo "============================="
  echo "Installing [$PLUGIN] ..."
  #  - https://www.jetbrains.com/help/idea/install-plugins-from-the-command-line.html#macos
  #  - https://www.jetbrains.com/help/idea/working-with-the-ide-features-from-command-line.html#b2db7cc1
  open -Wa "IntelliJ IDEA CE.app" --args installPlugins "${PLUGIN}"
  open -Wa "IntelliJ IDEA.app" --args installPlugins "${PLUGIN}"
done
