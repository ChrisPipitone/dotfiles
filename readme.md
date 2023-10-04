mv the files / dirs to .dotfiles/
I used arandr a giu for xrandr to position the screens properly, 
I saved that config as a file to ./screenlayout/screenlayout
then put that at the top of .xprofile

ln -sf ~/.dotfiles/.config/i3 ~/.config
ln -sf ~/.dotfiles/.fonts ~/.fonts
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.xprofile ~/.xprofile
