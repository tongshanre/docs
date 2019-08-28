
# 1.编译命令
nasm boot.asm -o boot.bin
dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc

# 2.bochsrc
###############################################################
# Configuration file for Bochs
###############################################################

# how much memory the emulated machine will have
 megs: 32

# filename of ROM images
 romimage: file=/usr/local/share/bochs/BIOS-bochs-latest        #/usr/share/bochs/BIOS-bochs-latest
 vgaromimage: file=/usr/local/share/bochs/VGABIOS-lgpl-latest   #/usr/share/vgabios/vgabios.bin

# what disk images will be used
 floppya: 1_44=a.img, status=inserted

# choose the boot disk.
 boot: floppy

# where do we send log messages?
# log: bochsout.txt

# disable the mouse
 mouse: enabled=0

# enable key mapping, using US layout as default.
 keyboard:  keymap=/usr/local/share/bochs/keymaps/x11-pc-us.map

