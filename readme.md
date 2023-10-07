mv the files / dirs to .dotfiles/
I used arandr a giu for xrandr to position the screens properly, 
I saved that config as a file to ./screenlayout/screenlayout
then put that at the top of .xprofile and added the --rate 143.97

ln -sf ~/.dotfiles/.config/i3 ~/.config
ln -sf ~/.dotfiles/.fonts ~/.fonts
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.xprofile ~/.xprofile

TO DO add other shortcuts made... im lazy

added picom. used xprop to find the WM_CLASS and set that value into the opacity rule


