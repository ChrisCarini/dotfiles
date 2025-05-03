#!/bin/bash

############################################
# AS OF 2025-04-25 THE BELOW DOES NOT WORK #
############################################
#case "$(uname -s)" in
#   Darwin)
#     LOGFILE="${HOME}/Library/Application Support/Microsoft/Teams/logs.txt"
#     ;;
#   Linux)
#     LOGFILE="${HOME}/.config/Microsoft/Microsoft Teams/logs.txt"
#     ;;
#   CYGWIN*|MINGW32*|MSYS*|MINGW*)
#     echo "Windows OS not supported. Try https://github.com/EBOOZ/TeamsStatus."
#     exit 1
#     ;;
#   *)
#     echo "OS not supported."
#     exit 1
#     ;;
#esac
#
#last_event=$(tac "${LOGFILE}" | grep -oh "eventData: s::;m::1;a::[0-9]" | head -n1)
#
#if [[ "${last_event}" =~ 0$ ]] || [[ "${last_event}" =~ 1$ ]]
#then
#  echo "☎️ In a call"
#  exit 0
#else
# echo "not in call"
# exit 1
#fi
############################################
# AS OF 2025-04-25 THE ABOVE DOES NOT WORK #
############################################


# From Brian Wilcox in LinkedIn Slack; references below:
#   - https://linkedin-randd.slack.com/archives/C0881KF9P/p1671080777406079 (original post in #SRE on 2022-12-14)
#     ```
#     And for today’s “I took too long to redo it” blog post… Because the sun is now setting here at 5:00pm… I’ve finally connected the camera stream events from my mac to my office nanoleaf lights. That way, when I enter a meeting, the lights turn up to 11 and I don’t look like a gollum cosplayer anymore!
#     It’s essentially
#       1. Log events (log stream --predicate 'subsystem=="com.apple.UVCExtension" AND category=="device" AND eventMessage matches ".*Stream\$"' )
#       2. Read by a script running from a launchd manifest
#         ```
#         <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#         <plist version="1.0">
#           <dict>
#             <key>Label</key>
#             <string>com.user.iot.office_light</string>
#             <key>ProgramArguments</key>
#             <array>
#                <string>/Users/bwilcox/Automation/highlight_during_meetings.sh</string>
#             </array>
#             <key>RunAtLoad</key>
#             <true/>
#             <key>StandardOutPath</key>
#             <string>/Users/bwilcox/Automation/highlight_during_meetings-stdout.log</string>
#             <key>StandardErrorPath</key>
#             <string>/Users/bwilcox/Automation/highlight_during_meetings-stderr.log</string>
#           </dict>
#         </plist>
#         ```
#       3. Which fires a shortcut
#       4. Which connects to a HomeAssistant webhook
#       5. Which starts a NodeRed workflow
#       6. Which checks if the light is on or the blinds are down and does the needful.
#     I’m sure others have already figured this crap out, but it’s super satisfying to progress from a “connected home” to an actually “smart home” 
#     ```
#
#     Brian also shared the below in the thread:
#     ```
#     #!/bin/bash
#     exec log stream --predicate 'subsystem=="com.apple.UVCExtension" AND category=="device" AND eventMessage matches ".*Stream\$"' | tee /dev/stderr | /usr/bin/sed -Eu 's/.*(Start|Stop).*/\1/' |
#     while read -r event; do
#       if [ "$event" = "Start" ]; then
#         echo "Camera On"
#         shortcuts run 'Turn On Light Meeting' &
#         sleep 10
#       elif [ "$event" = "Stop" ]; then
#         echo "Camera Off"
#         shortcuts run 'Turn Off Light Meeting' &
#         sleep 10
#       fi
#     done
#     ```
#
#   - https://linkedin-randd.slack.com/archives/D0931JJ7P/p1710768678936699 (my DM to Brian on 2024-03-18)
#     ```
#     :wave: heya buddy!
#     
#     I had saved https://linkedin-randd.slack.com/archives/C0881KF9P/p1671080777406079 like 10 mo ago according to slack, and am trying to give it a shot, but it looks like the filters don't work for recent versions of macos :confused:
#     
#     :information_source: *Was poking around, and found the following resources:*
#       1. https://stackoverflow.com/a/77920548 (this seems to work w/ my testing of Teams & Zoom)
#       2. https://apple.stackexchange.com/a/434652 (similar setup w/ script and shortcuts, etc)
#       3. https://blog.nilbus.com/automatically-turn-on-camera-lighting-using-homekit-on-macos/ (same as above; similar setup)
#     
#     (1) is most useful for 'what is the current filters', but (2) and (3) were fairly useful to see others (very similar, if not identical) impl of this :stuck_out_tongue: - specifically, `log stream --predicate 'process == "kernel" && (eventMessage contains "AppleH13CamIn::power_off_hardware" || eventMessage contains "AppleH13CamIn::power_on_hardware")'` seems to be showing events for when I turn on/off video in Teams and/or Zoom
#     
#     :question: *I have a few questions tho:*
#       a. What is the updated filtering you've landed on for latest versions of MacOS?
#       b. Is there any good Apple docs (ha!) or other resources you use to help answer ^ on new OS updates? So far, this approach seems brittle only because the events change between major os versions (based on another answer in the (1) :stackoverflow: post above. I tried some more broad filters for stuff like `camera` or `stream`, and it was either a ton, or seemingly nothing useful. _Teach me!_ :)
#       c. Why involve Mac shortcuts at all? Why not just call the webhook for HA directly from the script? (I'm sure there's some reason, but it's non-obv to me and I'd love to learn!)
#     ```

DEBOUNCE_SECONDS=2
LAST_RUN=0

exec log stream --predicate 'process == "kernel" && (eventMessage contains "AppleH13CamIn::power_off_hardware" || eventMessage contains "AppleH13CamIn::power_on_hardware")' | \
#  tee /dev/stderr | \
  /usr/bin/sed -Eu 's/.*AppleH13CamIn::power_(on|off)_hardware.*/\1/' | \
  while read -r event; do
    if [ "$event" = "on" ]; then
      CURRENT_TIME=$(date +%s)
      TIME_DIFF=$((CURRENT_TIME - LAST_RUN))
      if [ "$TIME_DIFF" -ge "$DEBOUNCE_SECONDS" ]; then
        echo "Running debounced action at $(date)"
        
        # Your debounced logic here
        echo "Camera On"
#        shortcuts run 'Turn On Light Meeting' &
        
        LAST_RUN=$CURRENT_TIME
      else
        echo "Debounced: Ignoring 'ON' event"
      fi
      
      
    elif [ "$event" = "off" ]; then
      echo "Camera Off"
#      shortcuts run 'Turn Off Light Meeting' &
    fi
    
    sleep 1
    echo "Slept for 1 seconds"
  done