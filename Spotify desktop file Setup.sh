#!/bin/sh
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#echo $SOURCE;
while true; do
	read -p "
	-------------------------------| About |------------------------------------

		This solution works towards the titlebar name of your Spotify client.
	It is worth mentioning that you cannot be playing anything in Spotify while
	applying the theme-change because the name in the titlebar is changed to the
	current song name. Best practice is to apply the change right after launch.

		We're going to begin with identifying your Spotify client. So if
	Spotify isn't running you should start it now.

		If Spotify is playing right now you should stop it so that the
	titlebar either says *Spotify Free* or *Spotify Premium*.
	
										:-)

	----------------------------------------------------------------------------

	Continue? (y/n) " yn
	case $yn in
		[Yy]* ) echo; echo "
		Great, let's do it!"; echo; break;;
		[Nn]* ) echo; echo "
		... ok, you were supposed to hit Y :-/"; echo; exit;;
		* ) echo; echo "
		! You must answer something I understand...  - Y or N"; echo;;
	esac

done

# Installerar variabel för senare användning...
$freeOrPremium

# Testa om vi har Free eller Premium...
# "2>/dev/null" är till för att ta bort utskrift av error-meddelanden som i detta fall är ointressanta
xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT "dark" -name "Spotify Premium" 2>/dev/null
if [ $? -eq 0 ];
	then
		freeOrPremium=Premium
		echo "

	Found Spotify Premium
"
elif [ $? -ne 0 ];
	then
		xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT "dark" -name "Spotify Free" 2>/dev/null
			if [ $? -eq 0 ];
				then
					freeOrPremium=Free
					echo "

	Found Spotify Free
"
	fi
else
	echo "

	Couldn't find any running Spotify Client :-(
"
	exit
fi

echo "
	... time to check directories to see if Spotify is installed as a package or snap
"
# Avgör om Spotify är installerat via paket eller snap så vi vet var vi ska ersätta nuvarande desktop-fil. Kollar snap först.
if [ -f "/var/lib/snapd/desktop/applications/spotify_spotify.desktop" ];
	then
		echo "

	Alright - Snap!
"
		sudo sh -c "cp /var/lib/snapd/desktop/applications/spotify_spotify.desktop /var/lib/snapd/desktop/applications/spotify_spotify.desktop_backup";
		echo "
	Made a backup of the original spotify.desktop just to be safe. You can find it in /var/lib/snapd/desktop/applications/
"
		
		sudo sh -c "cp '$SOURCE'/spotifySnap'$freeOrPremium' /var/lib/snapd/desktop/applications/spotify_spotify.desktop";
		echo "

	Done! Restart Spotify, right-click its icon to check out the new menu-item *Switch Titlebar to Dark Variant*
- You may have to log out and back in again (or perhaps reboot even) before you can see the new Spotify Desktop menu item
"

elif [ -f "/usr/share/applications/spotify.desktop" ];
	then
		echo "

	Alright - Pakage!
"
		sudo sh -c "cp /usr/share/applications/spotify.desktop /usr/share/applications/spotify.desktop_backup";
		echo "

	Made a backup of the original spotify.desktop just to be safe. You can find it in /usr/share/applications
"
		
		sudo sh -c "cp '$SOURCE'/spotifyPakage'$freeOrPremium' /usr/share/applications/spotify.desktop";
		echo "

	Done! Restart Spotify, right-click its icon to check out the new menu-item *Switch Titlebar to Dark Variant*
- You may have to log out and back in again (or perhaps reboot even) before you can see the new Spotify Desktop menu item
"
else
	echo "

	I couldn't find any spotify installation... :-/
"
	exit
	fi
