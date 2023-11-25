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
ascii=''
if [[ $1 != t ]]; then
y=$(printf '\033[1;33m')
n=$(printf '\033[0m')
b=$(printf '\033[48;5;21m\033[38;5;81m')
w=$(printf '\033[47m')
brand=$(getprop ro.product.brand)
if [[ $1 == a ]]; then
ascii=$(cat $2 | printf)"

"
else
	case $brand in
		samsung)
		ascii="
            ${b}#################################${n}
        ${b}#${w}   ${b}#${w}   ${b}#${w} ${b}###${w} ${b}#${w}   ${b}#${w} ${b}#${w} ${b}#${w} ${b}###${w} ${b}#${w}   ${b}#######${n}
     ${b}####${w} ${b}###${w} ${b}#${w} ${b}#${w}  ${b}#${w}  ${b}#${w} ${b}###${w} ${b}#${w} ${b}#${w}  ${b}##${w} ${b}#${w} ${b}#########${n}
   ${b}######${w}   ${b}#${w}   ${b}#${w} ${b}#${w} ${b}#${w} ${b}#${w}   ${b}#${w} ${b}#${w} ${b}#${w} ${b}#${w} ${b}#${w} ${b}#${w} ${b}########${n}
  ${b}#########${w} ${b}#${w} ${b}#${w} ${b}#${w} ${b}###${w} ${b}###${w} ${b}#${w} ${b}#${w} ${b}#${w} ${b}##${w}  ${b}#${w} ${b}#${w} ${b}####${n}
  ${b}#######${w}   ${b}#${w} ${b}#${w} ${b}#${w} ${b}###${w} ${b}#${w}   ${b}#${w}   ${b}#${w} ${b}###${w} ${b}#${w}   ${b}#${n}
    ${b}#################################${n}

"
    		;;
    	esac
fi
else
y='the'
n='is'
w=''
b=''
fi
shell=$SHELL
shell=${shell/"/data/data/com.termux/files/usr/bin/"/};
case $shell in
 	bash)
	shell=$shell" "$BASH_VERSION
	;;
	zsh)
	shell=$shell" "$(zsh --version)
	;;
esac
echo "${ascii}${y}$(whoami)@$(hostname)"
if [[ $(checkcmd termux-camera-info) != 0 && $(checkcmd jq) != 0 ]];
then
termux-camera-info | jq -r --arg y $y  --arg n $n '"\($y)Cameras: \($n)\(length)\n\($y)Capabilities: \($n)\(.[0].capabilities | join(", "))"'
termux-battery-status | jq -r --arg y $y  --arg n $n '"\($y)Battery Health: \($n)\(.health)\n\($y)Percentage: \($n)\(.percentage | tostring)%\n\($y)Temperature: \($n)\(.temperature | floor | tostring)°C"'
fi
echo "${y}OS: ${n}$(uname -o) $(getprop ro.build.version.release) $(uname -m)
${y}Host: ${n}${brand} $(getprop ro.vendor.product.model)
${y}Kernel: ${n}$(uname -rs)
${y}Uptime:${n}$(uptime -p | cut -d'p' -f 2)
${y}Shell: ${n}${shell}
${y}Packages: ${n}$((apt list --installed | wc -l) 2> /dev/null)
${y}Memory: ${n}$(toGB $(simplify ${marray[12]}))GB / $(toGB ${marray[7]})GB
${y}Termux Version: ${n}${TERMUX_VERSION}"
}
if [[ $1 != '' ]]; then
 while getopts "ath" OPTIONS; do
	case $OPTIONS in
		a)
		[[ $2 != '' ]] && main a $2 || (echo "You didn't provide a file (using default ascii)" && main)
		exit 1;
		;;
		t)
		[[ $(checkcmd termux-tts-speak) != 0 ]] && main t | termux-tts-speak || ''
		;;
		h)
		echo "termux-fetch: a simple bash script that displays information about your device like linux version, device brand and model, default termux shell and more.
you can even allow the script to retrieve more information like camera count and features, battery status and device temperature by installing the Termux:API app from F-droid (https://f-droid.org/en/packages/com.termux.api/) and installing the packages (termux-api) and (jq), by doing so you also can hear the output of this script be read by a tts voice
Options:

		-t: read script output with tts voice

		-h: display this help message

		-a: display content of the given file instead of ascii art

"
		;;
		?)
		echo "Usage: termux-fetch [-th] [-a ascii_file]"
		;;
	esac
done
else
 main
fi
