#!/bin/bash
###########################################################################
# Dependancies
# assuming you have a functioning storage
# visit https://aria2.github.io/
# aria2c 1.34+
# on OpenWRT/LEDE
# $ opkg install aria2
# Mac OS via homebrew
# $ brew install aria2c
# on iOS via Cydia
#Sam Bingner's (https://apt.bingner.com) or Apollo's (https://mcapollo.github.io/Public) repo
###########################################################################
##############       Functions      ########################################
############################################################################

# check if directory exits and writeable
validate_download_directory () {
if [ -d $1 ] && [ -w $1 ]
    then
        printf "Directory was Found and Writable\n\n"
    else
        printf "Error!!\n"
        printf "Directory WAS NOT Found or WAS NOT Writable.\n"
        create_missing_directory $1
fi
}

#Function to Make Missing Directory
create_missing_directory () {
printf "Would you like to Create it? (y/n)\n"             #create Missing Directory
read -n 1 MK_DEFAULT_DIR
    case $MK_DEFAULT_DIR in
    n|N)
        printf "\nExiting...\n"
        exit 2
        ;;
    y|Y|*)
        mkdir -p $1
        printf "Directory Created\n"
        ;;
    esac
return 0
}

#set download location
set_download_location () {
## Prompt to changer Download Directory
read -n 1 C_DIR
    case $C_DIR in
        n|N)
            echo ""
            read -p 'Enter Download Path:   ' DIR         # custom directory and check
            validate_download_directory $DIR              # check and create the directory if it doesnt exist.
            ;;
        y|Y|*)
            printf "Keeping Default Download Path.\n"
            validate_download_directory $DIR
            ;;
esac
}

#set aria's log location
set_log_location () {
printf "Keep Log Location as Default? (Y/N)?\n"
printf "Default: /tmp \n"
read -n 1 C_LOG_LOCATION
    case $C_LOG_LOCATION in
        n|N)
            echo ""
            read -p 'Enter Log Path:   ' LOG_LOCATION            # custom directory and check
            validate_download_directory $LOG_LOCATION
            LOG=$LOG_LOCATION/aria2c.log
            ;;
        y|Y|*)
            LOG_LOCATION=/tmp
            validate_download_directory $LOG_LOCATION
            LOG=$LOG_LOCATION/aria2c.log
            ;;
    esac
}

#Function to Change Output Name
change_downloaded_file_name (){
case $1 in
    n|N)
        echo "Enter Filename: (Don't forget the Extension)"
        read CUSTOM_FNAME
        echo "The Following will now Run."
        echo "--****------****----****------****----****------****----****------****----****------****--"
        echo "Path+filename-˯     Threads     Max Conn.     Segment Size      Log Location          "
        echo "aria2c "-d" "$DIR ""-o" "$CUSTOM_FNAME " -c "-s" "$THREADS" "--file-allocation=""$file_alloc" "-x" "$MAX" "-k" "$SEG" "$URL "> "$LOG" 2>&1 &"
        echo "--****------****----****------****----****------****----****------****----****------****--"
        echo "Press Enter to Continue"
        $SET_ARIA2C -d $DIR -o $CUSTOM_FNAME -c -s $THREADS --file-allocation=$file_alloc -x $MAX -k $SEG "$URL" > $LOG 2>&1 &
        ;;
    y|Y|*)
        echo "Didnt change Name"
        $SET_ARIA2C -d $DIR -c -s $THREADS --file-allocation=$file_alloc -x $MAX -k $SEG "$URL" > $LOG 2>&1 &
        ;;
esac
}

aria2c_check () {
if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]             # Check if Binary Exists and Executable
    then
        if  [ -d $SET_ARIA2C ]      #check if only the directory was entered.
            then
                printf "\nError!!\n"
                printf "You Must Enter the Full Path to the Binary File\n"
                exit 10
        fi
    printf "A Binary was Found and it has Correct Permissions\n"
    else
        printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
        exit 11
fi
}

set_threads(){
printf "\nSet Download Threads No.:  "
read THREADS
}
set_max_connections(){
printf "\nSet Max Connections per Host (Max=16):"
read MAX
}
set_segment_size(){
printf "\nSet Download Download Segment Size.(default 1M):  "
read SEG
return 1
}
set_alloc(){
printf "\nSet File Allocation Method  "
printf "\nPossible Values: none, prealloc, trunc, falloc\n"
printf "Default value= prealloc\n"
printf "for the default vaule Press Enter/Return\n"
read get_value
case $get_value in
none)
    file_alloc=none
    printf "\nYou Chose $file_alloc\n"
read -t 1 ok
    ;;
trunc)
    file_alloc=trunc
    printf "\nYou Chose $file_alloc\n"
read -t 1 ok
    ;;
falloc)
    file_alloc=falloc
    printf "\nYou Chose $file_alloc\n"
read -t 1 ok
    ;;
prealloc|*)
    file_alloc=prealloc
    printf "\nYou Chose $file_alloc\n"
read -t 1 ok
    ;;
esac
}

countdown()             #usage: countdown "00:00:05" #
(
IFS=:
set -- $*
secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
while [ $secs -gt 0 ]
do
sleep 1 &
printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
secs=$(( $secs - 1 ))
wait
done
echo    #empty line
echo message    # any command
)

############################################################################
##############      End of Functions      ##################################
############################################################################
########### Setting Fixed Variables ###############
SCRIPTNAME=$(basename $0)                         #
SCRIPTPATH="${0%/*}"                              #
MAX=16                                            #
THREADS=16                                        #
SEG=1M                                            #
file_alloc=prealloc
###################################################
#   Ascii Art from (http://patorjk.com) #
clear
while getopts "a" OPTS; do      # parse CLI input
    case $OPTS in
        a )
        set_threads
        set_max_connections
        set_segment_size
        set_alloc
        clear;
        echo "   __    ____  _  _  __    _  _  ___  ____  ____  ";
        echo "  /__\  (  _ \( \/ )/__\  ( \( )/ __)( ___)(  _ \ ";
        echo " /(__)\  )(_) )\  //(__)\  )  (( (__  )__)  )(_) )";
        echo "(__)(__)(____/  \/(__)(__)(_)\_)\___)(____)(____/ ";

        ;;
        * )
        printf "\ninvalid input. did you mean -a\n"
        exit 0;;
    esac
done
shift $(($OPTIND - 1))
echo "                 __         _______________  ________/\       ";
echo "  _________.__._/  |_  ____ \_____  \   _  \ \_____  )/ ______";
echo " /  ___<   |  |\   __\/  _ \ /  ____/  /_\  \  _(__  < /  ___/";
echo " \___ \ \___  | |  | (  <_> )       \  \_/   \/       \\___ \ ";
echo "/____  >/ ____| |__|  \____/\_______ \_____  /______  /____  >";
echo "     \/ \/                          \/     \/       \/     \/ ";
sleep 1
echo "      ________                      .__                    .___            ";
echo "      \______ \   ______  _  ______ |  |   _________     __| _/___________ ";
echo "       |    |  \ /  _ \ \/ \/ /    \|  |  /  _ \__  \   / __ |/ __ \_  __ \ ";
echo "       |    \`   (  <_> )     /   |  \  |_(  <_> ) __ \_/ /_/ \  ___/|  | \/";
echo "      /_______  /\____/ \/\_/|___|  /____/\____(____  /\____ |\___  >__|   ";
echo "              \/                  \/                \/      \/    \/       ";
sleep 1
#
printf "Welcome\n"
#CHOICE2=$1
printf "Make Your Choice\n"
printf " \"P\" to Open Memory Tool\n"
printf " \"D\" to Open Aria2 Downloader\n"
printf " \"A\" to Config Advanced Options\n"
printf " \"M\" to Open MiniDLNA Service Manager\n"
printf " \"Q\" to Exit\n"
read -n 1 CHOICE
echo " "

case $CHOICE in
        p|P)                # Memory Manager
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
                printf " How Can I Help You Today\n"
                printf "---------------.\n"
                printf "Press \"C\" For Combo Choice\n"
                printf "Press \"F\" to Check Current Memory\n"
                printf "Press \"P\" For Droping pagecache\n"
                printf "Press \"Q\" For Droping pagecache\n"
                read -n 1 INPUT
                    case $INPUT in
                            c|C)            # Combo Choice
                            ################## pagecache clearer ####################
                            printf " "
                            printf "\nPurging...\n"
                            printf "Before\n"
                            printf "-------------------------.\n"
                            free -m                                         ## check free memory.
                            printf "-------------------------.\n"
                            printf 1 > /proc/sys/vm/drop_caches               ## empty cache.
                            printf "After\n"
                            printf "-------------------------.\n"
                            free -m                                         ## check free memory.
                            printf "-------------------------.\n"
                            printf "Done\n"
                            sleep 1
                                ;;
                            f|F)        # check just free memory.
                                printf "\nCurrent Memory State\n"
                                printf "-------------------------.\n"
                                free -m
                                printf "-------------------------.\n"
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

        ;;
        d|D)            ################## Aria2c Downloader ####################
                clear
                echo "Opening Downloader"
                echo "Checking Aria2 installation and Permissions"
#######################################################################################################
################################### OS Selector #######################################
#######################################################################################################
        printf "Choose your OS\n"
        echo " "
        printf "  Press 'O' for OpenWRT/Linux\n "
        printf " Press 'i' for iOS\n "
        printf " Press 'm' for Mac OS\n "
        printf " Press 'z' to use Custom Download locations \n"
                read -n 1 OS
                    case $OS in             # Start of OS Selector cases

                        o|O)            # OpenWRT
                                    printf "\nStarting..."
                                    clear
                                    echo "   ____               __          _______ _______ ";
                                    echo "  / __ \              \ \        / /  __ \__   __|";
                                    echo " | |  | |_ __   ___ _ _\ \  /\  / /| |__) | | |   ";
                                    echo " | |  | | '_ \ / _ \ '_ \ \/  \/ / |  _  /  | |   ";
                                    echo " | |__| | |_) |  __/ | | \  /\  /  | | \ \  | |   ";
                                    echo "  \____/| .__/ \___|_| |_|\/  \/   |_|  \_\ |_|   ";
                                    echo "        | |                                       ";
                                    echo "        |_|                                       ";
                                SET_ARIA2C=/usr/bin/aria2c                        # Default for OpenWRT and iOS
                                    if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]                             # check binary existance and executable permissions.
                                        then
                                            printf "A Binary was Found and it has Correct Permissions\n"
                                        else
                                            printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
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
                                printf "\nStarting..."
                                clear
                                echo "  _    ____     _____ ";
                                echo " (_)  / __ \   / ____|";
                                echo "  _  | |  | | | (___  ";
                                echo " | | | |  | |  \___ \ ";
                                echo " | | | |__| |  ____) |";
                                echo " |_|  \____/  |_____/ ";
                                echo "                      ";
                                echo "                      ";
                                SET_ARIA2C=/usr/bin/aria2c                        # Default for OpenWRT and iOS
                                    if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]                             # check binary existance and executable permissions.
                                    then
                                    printf "A Binary was Found and it has Correct Permissions\n"
                                    else
                                    printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
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

                                printf "\nStarting..."
                                clear
                                echo "  __  __                 ____   _____ ";
                                echo " |  \/  |               / __ \ / ____|";
                                echo " | \  / | __ _  ___    | |  | | (___  ";
                                echo " | |\/| |/ _\` |/ __|   | |  | |\___ \ ";
                                echo " | |  | | (_| | (__    | |__| |____) |";
                                echo " |_|  |_|\__,_|\___|    \____/|_____/ ";
                                echo "                                      ";
                                echo "                                      ";


                                SET_ARIA2C=/usr/local/bin/aria2c                 # Default for MacOS via homebrew
                                if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]         # check binary existance and executable permissions.
                                    then
                                        printf "A Binary was Found and it has Correct Permissions\n"
                                    else
                                        printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
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
            change_downloaded_file_name $FNAME


#
#
#
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
                    printf "tail -f "$LOG"\n"
                    sleep 1
                    break
                    ;;
            esac
;;
#########################################################
############ End of Aria2c Downloader Script#############
#########################################################

        q|Q)
            printf "Exiting....\n\n"
            break
            ;;
#####################################################
################ MiniDLNA Service Manager ##########
#####################################################
        m|M)        # Manage MiniDLNA
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
                    printf " How Can I Help You Today\n"
                    printf "---------------.\n"
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
                                break
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
        ;;         # End of Manage MiniDLNA Service Manager from script's starting Case.

        a|A)                      # config extra options
            echo " "
            printf "Enabling Advanced Options. Restarting... \n"
            sh /$SCRIPTPATH/$SCRIPTNAME -a
            ;;

        *)                      # if you enter anything other than what's specified. Must be the last case
            echo " "
            printf "You Didn't Choose. Restarting... \n"
            sh /$SCRIPTPATH/$SCRIPTNAME
            ;;


        esac
