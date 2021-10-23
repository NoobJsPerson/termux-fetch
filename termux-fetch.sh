toGB(){	
	awk "BEGIN{print $(simplify $1)/1048576 }" | cut -c1-4
}
simplify(){
	echo $1 | cut -d'k' -f 1
}
sh <<< 'top > .tmp'
marray=($(cat .tmp | tr ';' '\n'))
rm .tmp
yellow=$(printf '\033[1;33m')
underline=$(printf '\033[1;4;93m')
normal=$(printf '\033[0m')
if [[ $(ls $PREFIX/bin | grep -c 'termux-camera-info') != 0 && $(ls $PREFIX/bin | grep -c 'jq') != 0 ]];
then
termux-camera-info | jq -r --arg yellow $yellow  --arg normal $normal --arg  underline $underline '"\($yellow)Cameras: \($normal)\(length)\n\($yellow)Capabilities: \($normal)\(.[0].capabilities | join(", "))"'
termux-battery-status | jq -r --arg yellow $yellow  --arg normal $normal --arg  underline $underline '"\($yellow)Health: \($normal)\(.health)\n\($yellow)Percentage: \($normal)\(.percentage | tostring)%\n\($yellow)Temperature: \($normal)\(.temperature | floor | tostring)°C"'
fi
echo "${yellow}OS: ${normal}$(uname -o) $(getprop ro.build.version.release) $(uname -m)
${yellow}Host: ${normal}$(getprop ro.product.brand) $(getprop ro.vendor.product.model)
${yellow}Kernel: ${normal}$(uname -rs)
${yellow}Uptime:${normal}$(uptime -p | cut -d'p' -f 2)
${yellow}Memory: ${normal}$(toGB $(($(simplify ${marray[15]}) - $(simplify ${marray[19]}))))GB / $(toGB ${marray[13]})GB
${yellow}Termux Version: ${normal}${TERMUX_VERSION}"
