#!/bin/sh

pacinstall() {
	sudo pacman -S --noconfirm --needed $1
}

gitinstall() {
	out="/tmp/$(echo "$1" | awk -F '/' '{print $(NF)}' | awk '{split($0,i,"."); print i[1]}')"
	git clone $1 ${out} && cd ${out} && makepkg -si --noconfirm && cd ~
}

aurinstall() {
	yay -S --noconfirm --needed $1
}

dotscopy() {
	out="/tmp/$(echo "$1" | awk -F '/' '{print $(NF)}' | awk '{split($0,i,"."); print i[1]}')"
	git clone $1 ${out} &&
	ls ${out}/config/ >/dev/null 2>&1; [ $? -eq 0 ] && mkdir -p $HOME/.config; cp -r ${out}/config/* $HOME/.config/ &&
	ls ${out}/local/bin/ >/dev/null 2>&1; [ $? -eq 0 ] && mkdir -p $HOME/.local/bin; cp -r ${out}/local/bin/* $HOME/.local/bin &&
	ls ${out}/local/share/ >/dev/null 2>&1; [ $? -eq 0 ] && mkdir -p $HOME/.local/share; cp -r ${out}/local/share/* $HOME/.local/share &&
	curl -L https://gitlab.com/mACKplAT/foosh/-/raw/simplepas/myencpas -o $HOME/.local/bin/myencpas &&
	ln -s $HOME/.config/shell/profile $HOME/.zprofile &&
	sleep 10
	cd ~
}

ls /tmp/pac.csv >/dev/null 2>&1
if (( $? != 0 )); then
	curl -L https://gitlab.com/hyprd/whypr/-/raw/main/pac.csv -o /tmp/pac.csv
fi

sudo chsh -s /bin/zsh $(whoami) >/dev/null 2>&1

while IFS=, read -r tag program; do
	case "$tag" in
		P) pacinstall "$program";;
		G) gitinstall "$program";;
		A) aurinstall "$program";;
		D) dotscopy "$program";;
	esac
done < /tmp/pac.csv
