## Linux Scripts

Gathering of useful set up and ad addition scripts for various Linux distros

### Add drivers to Macbook pro 2015

Linux does not natively have the drivers to run the mac camera, so you need to add them.
I have tried this in Debian, Ubuntu, Fedora - it works in all of these distros and there is no reason for it not to work on any other distro.

Original gist and credits [here](https://gist.github.com/ukn/a2f85e3420ae7d0f64db2274a9bc106b)

**Installation**

1 - Create a file `.sh` and name it as you please
2 - Give the file permission `sudo chmod +x filename`
3 - Run the file `sudo ./filename`

You can get an error along the line of `modprobe: FATAL: Module bdc_pci not found.`. This is OK, it means your system did not have that file.

4 - Run `sudo modprobe facetimehd`
5 - Reboot your system, and enjoy the working camera!

**Some useful posts that helped getting the info I needed**
[traditional method](https://askubuntu.com/questions/990218/camera-not-working-on-macbook-pro)
[useful comments](https://www.reddit.com/r/Fedora/comments/tgyrxv/macbook_pro_2013_camera_drivers/)
How to easily install kernel headers for your current kernel
`sudo apt install linux-headers-$(uname -r)`

### Nerd font installer

Can install all nerd fonts via a CLI selection. Very handy!
Credits to the [creator and maintainer](https://medium.com/thelinux/how-to-install-the-nerd-font-on-debian-ade41b331d89) and [repo](https://github.com/officialrajdeepsingh/nerd-fonts-installer)
`bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"`

### Zap plugin manager for zsh

By far my favourite plugin manager for zsh - it's so easy and handy and it doesn't really need set up at all.
Credits to [@chrisatmachine](https://github.com/zap-zsh/zap)
`zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1`

### Xclip - clipboard manager

A good article [here](https://opensource.com/article/19/7/xclip)

Not exactly a script but it is something I use in any distro

Debian
`sudo apt xclip`
To copy the content of a file and paste it with `CTRL+v`:
`xclip -sel clip README.md`
To output the clipboard content
`xclip -o`

### Zoxide - terminal navigator

Fantastic tool to shorten the `cd` piping. [Repo](https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
`curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash`
