#!/bin/sh

#  Modules.sh
#  
#
#  Created by syto203 on 7/1/19.
#  
############################################################################
######################### Modules ##########################################
source RUNPATH/syto203.sh
MEMORY_TOOL(){
clear
echo "___  ___ ________  ________________   __";
echo "|  \/  ||  ___|  \/  |  _  | ___ \ \ / /";
echo "| .  . || |__ | .  . | | | | |_/ /\ V / ";
echo "| |\/| ||  __|| |\/| | | | |    /  \ /  ";
echo "| |  | || |___| |  | \ \_/ / |\ \  | |  ";
echo "\_|  |_/\____/\_|  |_/\___/\_| \_| \_/  ";
echo "                                        ";
echo "                                        ";
echo " _____ _____  _____ _                   ";
echo "|_   _|  _  ||  _  | |                  ";
echo "  | | | | | || | | | |                  ";
echo "  | | | | | || | | | |                  ";
echo "  | | \ \_/ /\ \_/ / |____              ";
echo "  \_/  \___/  \___/\_____/              ";
echo "                                        ";
echo "                                        ";
#
printf "\n***************************\n"
printf "* Memory Tool *\n"
printf "***************************\n\n"
printf " How Can I Help You Today"
printf "\n---------------\n"
printf "Press \"C\" For Combo Choice\n"
printf "Press \"F\" to Check Current Memory\n"
printf "Press \"P\" For Droping pagecache\n"
printf "Press \"Q\" To Quite\n"
read -n 1 INPUT
case $INPUT in
c|C)            # Combo Choice
################## pagecache clearer ####################
printf " "
printf "\nPurging...\n"
printf "\n---------------\n"
printf "Before"
printf "\n-------------------------.\n"
free -m                                         ## check free memory.
printf "\n-------------------------.\n"
printf 1 > /proc/sys/vm/drop_caches               ## empty cache.
printf "After"
printf "\n-------------------------.\n"
free -m                                         ## check free memory.
printf "\n-------------------------.\n"
printf "Done\n"
sleep 1
;;
f|F)        # check just free memory.
printf "\nCurrent Memory State"
printf "\n-------------------------.\n"
free -m
printf "\n-------------------------.\n"
;;
p|P)
printf "\nPurging...\n"
echo 1 > /proc/sys/vm/drop_caches
;;
q|Q|*)
printf "\nExiting...\n"
exit 1
;;
esac
################## End of pagecache clearer ####################
}

MINIDLNA_MANAGER(){
#####################################################
################ MiniDLNA Service Manager ##########
#####################################################
clear
#
echo "___  ____       _______ _      _   _   ___  ";
echo "|  \/  (_)     (_)  _  \ |    | \ | | / _ \ ";
echo "| .  . |_ _ __  _| | | | |    |  \| |/ /_\ \ ";
echo "| |\/| | | '_ \| | | | | |    | . \` ||  _  |";
echo "| |  | | | | | | | |/ /| |____| |\  || | | |";
echo "\_|  |_/_|_| |_|_|___/ \_____/\_| \_/\_| |_/";
echo "                                            ";
echo "                                            ";
#
printf "\n***************************\n"
printf "* MiniDLNA Service Manager *\n"
printf "***************************\n"
printf " How Can I Help You Today"
printf "\n---------------. \n"
printf "Press ""S"" to Start MiniDLNA service\n"
printf "Press ""H"" to Stop MiniDLNA Service\n"
printf "Press ""E"" to Enable MiniDLNA Service\n"
printf "Press ""D"" to Disable MiniDLNA Service\n"
printf "Press ""L"" to Reload MiniDLNA Service\n"
printf "Press ""R"" to Restart MiniDLNA Service\n"
printf "Press ""B"" to Delete Current MiniDLNA Database\n"
printf "Press ""Q"" to Quit MiniDLNA Service Manager\n"

read -n 1 MANAGE
case $MANAGE in             # Selector Start

s|S)
printf "\nStarting MiniDLNA\n"
/etc/init.d/minidlna start                # start minidlna service
printf "Start Service Done\n"
;;
h|H)
printf "\nStopping MiniDLNA\n"
/etc/init.d/minidlna stop                # stop minidlna service
printf "MiniDLNA Service Stopped\n"
;;
e|E)
printf "\nEnable MiniDLNA\n"
/etc/init.d/minidlna enable                # enable minidlna service
printf "MiniDLNA Service Enabled\n"
;;
d|D)
printf "\nDisable MiniDLNA\n"
/etc/init.d/minidlna disable                # Disable minidlna service
printf "MiniDLNA Service Disabled\n"
;;
l|L)
printf "\nReload MiniDLNA\n"
/etc/init.d/minidlna reload                # Reload minidlna service
printf "MiniDLNA service Reloaded\n"
;;
r|R)                                           # Restart minidlna service
printf "\nRestarting MiniDLNA\n"
/etc/init.d/minidlna restart
printf "Restart Finished\n"
;;
b|B)
printf "\nIf your database is large it will take sometime to Populate\n"
printf "Delete Databse file too? (Y/N)\n"
read -n 1 DEL_DB1
case $DEL_DB1 in
y|Y)
printf "\nAre You Sure? (Y/N)\n"
read -n1 DEL_DB2
case $DEL_DB2 in
n|N)
echo "\nDatabase File NOT deleted"
;;
y|Y)
printf "\nLocating and Deleteing Database...\n"
uci show minidlna | awk -F"'" '/db_dir/{print $2}' | ( read DB; (rm $DB/files.db) && printf "Database Deleted\n" || printf " \nDatabase file is already Deleted\n")
printf "Restart the MiniDLNA service to re-make and Populate your Database\n"
;;
esac     # End Inner case switch
;;
n|N)
echo "\ncool cool cool"
;;
esac
;; # end of b|B)
q|Q)                        # Quit
printf "\nExiting\n"
exit
;;
*)
echo " "
printf "You Didn't Choose. Exiting...\n"
exit 10
;;
esac                        # Selector End
###########################################################
############ End of MiniDLNA Service Manager ##############
###########################################################
}

DOWNLOADER_ARIA(){
clear
echo "Opening Downloader"
clear
echo "    ____                      __                __         ";
echo "   / __ \____ _      ______  / /___  ____ _____/ /__  _____";
echo "  / / / / __ \ | /| / / __ \/ / __ \/ __ \`/ __  / _ \/ ___/";
echo " / /_/ / /_/ / |/ |/ / / / / / /_/ / /_/ / /_/ /  __/ /    ";
echo "/_____/\____/|__/|__/_/ /_/_/\____/\__,_/\__,_/\___/_/     ";
echo "                                                           ";
#######################################################################################################
################################### OS Selector #######################################
#######################################################################################################
printf "Choose your OS\n"
echo
printf "  Press \"O\" for OpenWRT/Linux\n "
printf " Press \"i\" for iOS\n "
printf " Press \"m\" for Mac OS\n "
printf " Press \"z\" to use Custom Download locations (ADVANCED)\n"
read -n 1 OS
case $OS in             # Start of OS Selector cases

o|O)            # OpenWRT
OS_LOGO=openwrt
printf "\nStarting..."
clear
OPENWRT_LOGO(){
echo "   ____               __          _______ _______ ";
echo "  / __ \              \ \        / /  __ \__   __|";
echo " | |  | |_ __   ___ _ _\ \  /\  / /| |__) | | |   ";
echo " | |  | | '_ \ / _ \ '_ \ \/  \/ / |  _  /  | |   ";
echo " | |__| | |_) |  __/ | | \  /\  /  | | \ \  | |   ";
echo "  \____/| .__/ \___|_| |_|\/  \/   |_|  \_\ |_|   ";
echo "        | |                                       ";
echo "        |_|                                       ";
}
OPENWRT_LOGO
SET_ARIA2C=/usr/bin/aria2c                        # Default for OpenWRT and iOS
if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]                             # check binary existance and executable permissions.
then
printf "A Binary was Found and it has Correct Permissions\n"
else
printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
printf "OR you Chose the Wrong OS\n"
exit 1
fi
echo "Setting Work Directories"
echo "Setting Download Directory"
DIR=/mnt/sda1/usb/video
printf "\nKeep Download path as Default?  (default: /mnt/sda1/usb/video)\n (Y/N)?\n"
set_download_location
printf "Setting Log Directory\n"
set_log_location
printf "Download Loation: "$DIR"\n"
printf "Log Location: "$LOG"\n"
touch /tmp/.aria2c
CHECK1=/tmp/.aria2c
echo "Continuing..."
sleep 1
#read ok
;;
i|I)            # iOS
OS_LOGO=ios
printf "\nStarting..."
clear
IOS_LOGO(){
echo "  _    ____     _____ ";
echo " (_)  / __ \   / ____|";
echo "  _  | |  | | | (___  ";
echo " | | | |  | |  \___ \ ";
echo " | | | |__| |  ____) |";
echo " |_|  \____/  |_____/ ";
echo "                      ";
echo "                      ";
}
IOS_LOGO
SET_ARIA2C=/usr/bin/aria2c                        # Default for OpenWRT and iOS
if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]                             # check binary existance and executable permissions.
then
printf "A Binary was Found and it has Correct Permissions\n"
else
printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
printf "OR you Chose the Wrong OS\n"
exit 1
fi
echo "Setting Work Directories"
echo "Setting Download Directory"
DIR=/var/mobile/Downloads
printf "\nKeep Download path as Default?  (default: /var/mobile/Downloads)\n (Y/N)?\n"
set_download_location
printf "Setting Log Directory\n"
set_log_location
printf "Download Loation: "$DIR"\n"
printf "Log Location: "$LOG"\n"
echo "Continuing..."
sleep 1
#read ok
;;
m|M)            # Mac OS
OS_LOGO=mac
printf "\nStarting..."
clear
MAC_OS_LOGO(){
echo "  __  __                 ____   _____ ";
echo " |  \/  |               / __ \ / ____|";
echo " | \  / | __ _  ___    | |  | | (___  ";
echo " | |\/| |/ _\` |/ __|   | |  | |\___ \ ";
echo " | |  | | (_| | (__    | |__| |____) |";
echo " |_|  |_|\__,_|\___|    \____/|_____/ ";
echo "                                      ";
echo "                                      ";
}
MAC_OS_LOGO
SET_ARIA2C=/usr/local/bin/aria2c                 # Default for MacOS via homebrew
if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]         # check binary existance and executable permissions.
then
printf "A Binary was Found and it has Correct Permissions\n"
else
printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
printf "OR you Chose the Wrong OS\n"
exit 1
fi
echo "aria2c has correct permissions"
echo "Setting Working Directories"
echo "Setting Download Directory"
DIR=~/Downloads
printf "\nKeep Download path as Default?  (default: ~/Downloads)\n (Y/N)?\n"

set_download_location
echo "Setting Log Directory"
set_log_location
echo "Download Location= "$DIR""
echo "Log Location= "$LOG""
touch /tmp/.aria2c
echo "Continuing..."
sleep 1
#read ok
;;
z|Z)                                                    # Custom Inputs
printf "\nStarting..."
clear
#
echo "_________                 __                      ";
echo "\_   ___ \ __ __  _______/  |_  ____   _____      ";
echo "/    \  \/|  |  \/  ___/\   __\/  _ \ /     \     ";
echo "\     \___|  |  /\___ \  |  | (  <_> )  Y Y  \    ";
echo " \______  /____//____  > |__|  \____/|__|_|  /    ";
echo "        \/           \/                    \/     ";
echo "       .___                 __         .__  .__   ";
echo "       |   | ____   _______/  |______  |  | |  |  ";
echo "       |   |/    \ /  ___/\   __\__  \ |  | |  |  ";
echo "       |   |   |  \\___ \  |  |  / __ \|  |_|  |__";
echo "       |___|___|  /____  > |__| (____  /____/____/";
echo "                \/     \/            \/           ";
#
read -p "Aria2c's Binary Location (default= /usr/bin/aria2c):   " SET_ARIA2C
aria2c_check $SET_ARIA2C
read -p 'Enter Download Path:   ' DIR                # custome directory and check
validate_download_directory $DIR
printf "Setting Log Directory\n"
set_log_location
printf "Download Loation: "$DIR"\n"
printf "Log Location: "$LOG"\n"
echo "Continuing..."
sleep 1
;;      #custom install case
*)
printf "\nYou Didn't Choose. Exiting...\n"
exit 10
;;
esac                # End of OS Selector cases
#########################################################################
################### Start of Download Script ############################
#########################################################################
clear
sleep 1
case $OS_LOGO in
openwrt)
OPENWRT_LOGO
;;
ios)
IOS_LOGO
;;
mac)
MAC_OS_LOGO
;;
esac
echo
echo "*************************"
echo "* Aria2 Auto-Downloader *"
echo "*************************"
echo "Hi,"
echo "Input Download Link."
echo "----------------"
read -p 'Link= ' URL
echo " "
echo "##################################################################"
echo "You Entered"
echo $URL
echo "##################################################################"
### Change output filename ###
printf "Keep Original Filename (Y/N)?\n"
read -n 1 FNAME
echo " "
download_http_final $FNAME

echo "Initiating......"
sleep 1
echo "The Download is in the Background"
echo "Press M to monitor or any key to Exit"
read -n1 INPUT
case $INPUT in
m|M)
clear;printf "Monitoring....\n"
sleep 1
tail -f $LOG
;;
*)
printf "Exiting.....\n"
printf "To Stop Downloading\nkillall aria2c\n"
printf "To Monitor\ntail -f "$LOG"\n"
sleep 1
exit
;;
esac
#########################################################
############ End of Aria2c Downloader Script#############
#########################################################
}           # End of DOWNLOADER_ARIA
