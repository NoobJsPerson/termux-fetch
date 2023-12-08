# termux-fetch
A small bash script that gives info about your device
![Screenshot of the output of termux-fetch](screenshot.jpg)
### Instalation
- Before anything, you should clone this repository
```git clone https://github.com/noobjsperson/termux-fetch```
1. Now you could install the provided deb file with
```apt install ./nameofdeb.deb```

2. Or you could package the deb manually following the next steps:
- Install `termux-create-package` with 
```pkg install termux-create-package```
- Execute the following command
```termux-create-package manifest.json```
- Install the resulting deb file
```apt install ./nameofdeb.deb```

### Credits
noobjsperson: original author
owokitty: helped me fix the script for xfce4-terminal, qterminal and aterm
