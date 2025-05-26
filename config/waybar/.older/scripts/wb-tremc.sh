#!/bin/sh

transmission-remote -l 1>/dev/null 2>/dev/null;
if (( $? == 0 )); then
	transmission-remote -l | grep % |
		sed " # The letters are for sorting and will not appear.
		s/.*Stopped.*/A /;
		s/.*Seeding.*/Z /;
		s/.*100%.*/N /;
		s/.*Idle.*/B /;
		s/.*Uploading.*/L /;
		s/.*%.*/M /;"|
			sort -h | uniq -c | awk '{print $3" "$1}' | paste -sd ' ' -
else
	echo " 0"
fi

#case $BLOCK_BUTTON in
#	1) setsid -f "$TERMINAL" -e tremc ;;
#	2) td-toggle ;;
#	3) notify-send "🌱 Torrent module" "\- Left click to open tremc.
#- Middle click to toggle transmission.
#- Shift click to edit script.
#Module shows number of torrents:
#: paused
#: idle (seeds needed)
#: uploading (unfinished)
#: downloading
#: done
#: done and seeding" ;;
#	6) "$TERMINAL" -e "$EDITOR" "$0" ;;
#esac
