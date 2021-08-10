yellow=$(printf '\033[1;33m')
underline=$(printf '\033[1;4;93m')
normal=$(printf '\033[0m')
termux-camera-info | jq -r --arg yellow $yellow  --arg normal $normal --arg  underline $underline '"\($underline)General Info:\($normal)\n\($yellow)Cameras: \($normal)\(length)\n\($yellow)Capabilities: \($normal)\(.[0].capabilities | join(", "))"'
termux-battery-status | jq -r --arg yellow $yellow  --arg normal $normal --arg  underline $underline '"\($underline)Battery Info:\($normal)\n\($yellow)Health: \($normal)\(.health)\n\($yellow)Percentage: \($normal)\(.percentage | tostring)%\n\($yellow)Temperature: \($normal)\(.temperature | floor | tostring)°C"'
IFS=' ' read -ra array <<< "$(uptime)"
uptimestr=${array[2]}
if [ "${array[3]}" = "min," ]
then uptimestr+=" min(s)"
else uptimestr+="hour(s)"
fi
echo "${underline}General Info:${normal}
${yellow}OS: ${normal}$(uname -o) $(getprop ro.build.version.release) $(uname -m)
${yellow}Host: ${normal}$(getprop ro.product.brand) $(getprop ro.vendor.product.model)
${yellow}Kernel: ${normal}$(uname -rs)
${yellow}Uptime: ${normal}${uptimestr/,/' '}
${yellow}Termux Version: ${normal}${TERMUX_VERSION}"