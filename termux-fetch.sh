yellow=$(printf '\033[1;33m')
underline=$(printf '\033[1;4;93m')
normal=$(printf '\033[0m')
termux-camera-info | jq -r --arg yellow $yellow  --arg normal $normal --arg  underline $underline '"\($underline)General Info:\($normal)\n\($yellow)Cameras: \($normal)\(length)"'
termux-battery-status | jq -r --arg yellow $yellow  --arg normal $normal --arg  underline $underline '"\($underline)Battery Info:\($normal)\n\($yellow)Health: \($normal)\(.health)\n\($yellow)Percentage: \($normal)\(.percentage | tostring)%\n\($yellow)Temperature: \($normal)\(.temperature | tostring)"
