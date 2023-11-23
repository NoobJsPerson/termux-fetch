#!/usr/bin/bash
toGB(){
	awk "BEGIN{print $(simplify $1)/1048576 }" | cut -c1-4
}
simplify(){
	echo $1 | cut -d'k' -f 1
}
checkcmd(){
	ls $PREFIX/bin | grep -c $1
}
main(){
marray=($(free | tr ';' '\n'))
if [[ $1 != t ]]; then
yellow=$(printf '\033[1;33m')
normal=$(printf '\033[0m')
else
yellow='the'
normal='is'
fi
echo "${yellow}$(whoami)@$(hostname)"
if [[ $(checkcmd termux-camera-info) != 0 && $(checkcmd jq) != 0 ]];
then
termux-camera-info | jq -r --arg yellow $yellow  --arg normal $normal '"\($yellow)Cameras: \($normal)\(length)\n\($yellow)Capabilities: \($normal)\(.[0].capabilities | join(", "))"'
termux-battery-status | jq -r --arg yellow $yellow  --arg normal $normal '"\($yellow)Health: \($normal)\(.health)\n\($yellow)Percentage: \($normal)\(.percentage | tostring)%\n\($yellow)Temperature: \($normal)\(.temperature | floor | tostring)°C"'
fi
echo "${yellow}OS: ${normal}$(uname -o) $(getprop ro.build.version.release) $(uname -m)
${yellow}Host: ${normal}$(getprop ro.product.brand) $(getprop ro.vendor.product.model)
${yellow}Kernel: ${normal}$(uname -rs)
${yellow}Uptime:${normal}$(uptime -p | cut -d'p' -f 2)
${yellow}Packages: ${normal}$((apt list --installed | wc -l) 2> /dev/null)
${yellow}Memory: ${normal}$(toGB $(simplify ${marray[12]}))GB / $(toGB ${marray[7]})GB
${yellow}Termux Version: ${normal}${TERMUX_VERSION}"
}
getopts t o
[[ $(checkcmd termux-tts-speak) != 0 && $o != '?' ]] && main t | termux-tts-speak || main
