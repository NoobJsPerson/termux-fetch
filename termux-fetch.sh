#!/data/data/com.termux/files/usr/bin/bash
TEMP=`getopt -o a:b:cdht --long disable-camera-info,disable-battery-status,help,ascii:,brand:,tts -- "$@"`
eval set -- "$TEMP"
noop(){
	printf ''
}
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
if [[ $1 != *t* ]]; then
y=$(printf '\033[1;33m')
n=$(printf '\033[0m')
w=$(printf '\033[47m')
realbrand=$(getprop ro.product.brand)
[[ $1 == *b* ]] && brand=$2 || brand=$realbrand
if [[ $1 == *a* ]]; then
ascii=$(printf "$(cat $2)")"

"
else
	case $brand in
		samsung)
		b=$(printf '\033[48;5;21m\033[38;5;81m')
		ascii="
            ${b}                                 ${n}
        ${b} ${w}   ${b} ${w}   ${b} ${w} ${b}   ${w} ${b} ${w}   ${b} ${w} ${b} ${w} ${b} ${w} ${b}   ${w} ${b} ${w}   ${b}       ${n}
     ${b}    ${w} ${b}   ${w} ${b} ${w} ${b} ${w}  ${b} ${w}  ${b} ${w} ${b}   ${w} ${b} ${w} ${b} ${w}  ${b}  ${w} ${b} ${w} ${b}         ${n}
   ${b}      ${w}   ${b} ${w}   ${b} ${w} ${b} ${w} ${b} ${w} ${b} ${w}   ${b} ${w} ${b} ${w} ${b} ${w} ${b} ${w} ${b} ${w} ${b} ${w} ${b}        ${n}
  ${b}         ${w} ${b} ${w} ${b} ${w} ${b} ${w} ${b}   ${w} ${b}   ${w} ${b} ${w} ${b} ${w} ${b} ${w} ${b}  ${w}  ${b} ${w} ${b} ${w} ${b}    ${n}
  ${b}       ${w}   ${b} ${w} ${b} ${w} ${b} ${w} ${b}   ${w} ${b} ${w}   ${b} ${w}   ${b} ${w} ${b}   ${w} ${b} ${w}   ${b} ${n}
    ${b}                                 ${n}

"

    		;;
    		oppo)
    		g=$(printf '\033[48;5;34m')
		ascii="${g}                                         ${n}
${g}                                         ${n}
${g}      ${w}     ${g}    ${w}    ${g}    ${w}    ${g}   ${w}     ${g}      ${n}
${g}     ${w} ${g}    ${w}  ${g} ${w} ${g}    ${w}  ${g} ${w} ${g}    ${w}  ${g} ${w} ${g}    ${w}  ${g}     ${n}
${g}     ${w} ${g}    ${w}  ${g} ${w} ${g}    ${w}  ${g} ${w} ${g}    ${w}  ${g} ${w} ${g}    ${w}  ${g}     ${n}
${g}      ${w}     ${g}  ${w}      ${g}  ${w}      ${g}   ${w}     ${g}      ${n}
${g}             ${w} ${g}       ${w} ${g}                   ${n}
${g}             ${w} ${g}       ${w} ${g}                   ${n}
${g}                                         ${n}
${g}                                         ${n}

"

    		;;
		*)
		ascii="
    ___
    \##\\
     \##\\
      \##\\
       \##\\
        \##\\
         \##\\
         /##/
        /##/
       /##/
      /##/
     /##/    ______________
    /##/    |##############|

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
[[ $1 != *c* ]] && termux-camera-info | jq -r --arg y $y  --arg n $n '"\($y)Cameras: \($n)\(length)\n\($y)Capabilities: \($n)\(.[0].capabilities | join(", "))"' || noop
[[ $1 != *d* ]] && termux-battery-status | jq -r --arg y $y  --arg n $n '"\($y)Battery Health: \($n)\(.health)\n\($y)Percentage: \($n)\(.percentage | tostring)%\n\($y)Temperature: \($n)\(.temperature | floor | tostring)°C"' || noop
fi
if [[ $(getprop vzw.os.rooted) == true ]]; then
rooted="Rooted"
fi
echo "${y}OS: ${n}$(uname -o) $(getprop ro.build.version.release) $(uname -m)
${y}Host: ${n}${realbrand} $(getprop ro.vendor.product.model) ${rooted}
${y}Kernel: ${n}$(uname -rs)
${y}Uptime:${n}$(uptime -p | cut -d'p' -f 2)
${y}Shell: ${n}${shell}
${y}Packages: ${n}$((apt list --installed | wc -l) 2> /dev/null)
${y}Memory: ${n}$(toGB $(simplify ${marray[12]}))GB / $(toGB ${marray[7]})GB
${y}Termux Version: ${n}${TERMUX_VERSION}
${extra}"
}
if [[ $1 != '' ]]; then
for ((i=1; i<=$#; i++)) do
	j=$(expr ${i} + 1)
	case "${!i}" in
		-a| --ascii)
		if [[ "${!j}" != '' ]]; then
		 param1="${param1}a"
		 param2="${!j}"
		else
		 echo "You didn't provide a file (using default ascii)"
		fi;
		;;
		-t|--tts)
		if [[ $(checkcmd termux-tts-speak) != 0 ]]; then param1="${param1}t"
		fi
		;;
		-b|--brand)
		if [[ "${!j}" != '' ]]; then
		param1="${param1}b"
		param2="${!j}"
		else
		echo "You didn't provide a brand (using your device's brand)"
		fi
		;;
		-c|--disable-camera-info)
		param1="${param1}c"
		param2="${!j}"
		;;
		-d|--disable-battery-status)
		param1="${param1}d"
		param2="${!j}"
		;;
		-h|--help)
		echo "termux-fetch: a simple bash script that displays information about your device like linux version, device brand and model, default termux shell and more.
you can even allow the script to retrieve more information like camera count and features, battery status and device temperature by installing the Termux:API app from F-droid (https://f-droid.org/en/packages/com.termux.api/) and installing the packages (termux-api) and (jq), by doing so you unlock the ability to hear the output of this script be read by a tts voice using the -t flag
Options:

		-t, --tts: reads script output with tts voice (requires Termux:API app and termux-api and jq packages)

		-h, --help: displays this help message

		-a, --ascii: displays content of the given file instead of ascii art

		-b, --brand: displays the ascii art of the given brand (has higher priority than -a)

		-c, --disable-camera-info: disables showing camera informations

		-d, --disable-battery-info: disables showing battery status

"
		exit 0;
		;;
		?)
		echo "Usage: termux-fetch [-th] [-a ascii_file] [-b brand]"
		exit 0;
		;;
	esac
done
[[ $param1 == *t* ]] && main $param1 $param2 | termux-tts-speak || main $param1 $param2
else
 main
fi
