#!/usr/bin/env bash
####
# PERSONAL INTELLIJ PLUGINS - IntelliJ Community & Ultimate
####

if ! is-macos -o ! is-executable wget -o ! is-executable unzip; then
  echo "Skipped: IntelliJ Plugins"
  return
fi

function install_ij_plugin_to_app() {
  #  - https://www.jetbrains.com/help/idea/install-plugins-from-the-command-line.html#macos
  #  - https://www.jetbrains.com/help/idea/working-with-the-ide-features-from-command-line.html#b2db7cc1
  local APP_NAME="$1"
  local PLUGINS=("${@:2}") # Capture all arguments starting from the second one as an array
  echo "================================="
  echo "Installing the following plugins to [${APP_NAME}]:"
  for PLUGIN in "${PLUGINS[@]}"; do
    echo "  - $PLUGIN"
  done
  open -Wa "$APP_NAME" --args installPlugins "${PLUGINS[@]}"
  echo "================================="
}

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
  com.intellij.bigdatatools.core                                 # `Big Data Tools Core` - https://plugins.jetbrains.com/plugin/21713-big-data-tools-core
  net.codestats.plugin.atom.intellij                             # `Code::Stats` - https://plugins.jetbrains.com/plugin/8393-code-stats
  dev.turingcomplete.intellijdevelopertoolsplugins               # `Developer Tools` - https://plugins.jetbrains.com/plugin/21904-developer-tools
  org.jetbrains.completion.full.line                             # `Full Line Code Completion` - https://plugins.jetbrains.com/plugin/14823-full-line-code-completion
  intellij.git.commit.modal                                      # `Git Modal Commit Interface` - https://plugins.jetbrains.com/plugin/26647-git-modal-commit-interface
  com.github.copilot                                             # `GitHub Copilot - https://plugins.jetbrains.com/plugin/17718-github-copilot
  zielu.gittoolbox                                               # `GitToolBox` - https://plugins.jetbrains.com/plugin/7499-gittoolbox
  org.jetbrains.plugins.go                                       # `Go` - https://plugins.jetbrains.com/plugin/9568-go
  com.intellij.lang.jsgraphql                                    # `GraphQL` - https://plugins.jetbrains.com/plugin/8097-graphql
  tanvd.grazi                                                    # `Grazie` - https://plugins.jetbrains.com/plugin/12175-grazie
  com.dmarcotte.handlebars                                       # `Handlebars / Mustache` - https://plugins.jetbrains.com/plugin/6884-handlebars-mustache
  com.intellij.ideolog                                           # `Ideolog` - https://plugins.jetbrains.com/plugin/9746-ideolog
  indent-rainbow.indent-rainbow                                  # `Indent Rainbow` - https://plugins.jetbrains.com/plugin/13308-indent-rainbow
  com.jetbrains.hackathon.indices.viewer                         # `Index Viewer` - https://plugins.jetbrains.com/plugin/13029-index-viewer
  com.jetbrains.plugins.ini4idea                                 # `Ini` - https://plugins.jetbrains.com/plugin/6981-ini
  org.jetbrains.kotlin                                           # `Kotlin` - https://plugins.jetbrains.com/plugin/6954-kotlin
  name.kropp.intellij.makefile                                   # `Makefile Language` - https://plugins.jetbrains.com/plugin/9333-makefile-language
  com.intellij.mermaid                                           # `Mermaid` - https://plugins.jetbrains.com/plugin/20146-mermaid
  com.firsttimeinforever.intellij.pdf.viewer.intellij-pdf-viewer # `PDF Viewer` - https://plugins.jetbrains.com/plugin/14494-pdf-viewer
  com.jetbrains.php                                              # `PHP` - https://plugins.jetbrains.com/plugin/6610-php
  com.jetbrains.intellij.code.search.polaris                     # `Polaris` - https://plugins.jetbrains.com/plugin/18568-polaris
  org.nik.presentation-assistant                                 # `Presentation Assistant` - https://plugins.jetbrains.com/plugin/7345-presentation-assistant
  PsiViewer                                                      # `PsiViewer` - https://plugins.jetbrains.com/plugin/227-psiviewer
  izhangzhihao.rainbow.brackets                                  # `Rainbow Brackets` - https://plugins.jetbrains.com/plugin/10080-rainbow-brackets
  ru.meanmail.plugin.requirements                                # `Requirements` - https://plugins.jetbrains.com/plugin/10837-requirements
  com.intellij.properties.bundle.editor                          # `Resource Bundle Editor` - https://plugins.jetbrains.com/plugin/17035-resource-bundle-editor
  com.jetbrains.rust                                             # `Rust` - https://plugins.jetbrains.com/plugin/22407-rust
  org.intellij.scala                                             # `Scala` - https://plugins.jetbrains.com/plugin/1347-scala
  String Manipulation                                            # `String Manipulation` - https://plugins.jetbrains.com/plugin/2162-string-manipulation
  com.wakatime.intellij.plugin                                   # `WakaTime` - https://plugins.jetbrains.com/plugin/7425-wakatime
)

# INSTALL IC
IDEA_CE="IntelliJ IDEA CE.app"
# Check if the app is installed before proceeding below
if [ -d "/Applications/${IDEA_CE}" ]; then
  community_plugins=(
    "PythonCore"     # `Python (IC)` - https://plugins.jetbrains.com/plugin/7322-python-community-edition
    "${plugins[@]}"  # All the plugins from above
  )
  install_ij_plugin_to_app "${IDEA_CE}" "${community_plugins[@]}"
fi


# INSTALL ALL IU
ultimate_plugins=( 
  "Pythonid"       # `Python (IU)` - https://plugins.jetbrains.com/plugin/631-python
  "${plugins[@]}"  # All the plugins from above
)
ls /Applications/ | \grep -E "^IntelliJ IDEA .*.app$" | \grep -v "${IDEA_CE}" | while IFS= read -r ide ; do
  install_ij_plugin_to_app "${ide}" "${ultimate_plugins[@]}"
done
