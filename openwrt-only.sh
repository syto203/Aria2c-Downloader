#!/bin/ash
# Created by syto203
# mainly for use on OpenWRT router as a "Background Downloader"
# just don't tell anyone you are using it xD
###########################################################################
# Dependancies
# assuming you have a functioning storage
# visit https://aria2.github.io/
# aria2c 1.34+
# on OpenWRT/LEDE
# $ opkg install aria2
# Mac OS via homebrew
# on iOS via Cydia
# Sam Bingner's (https://apt.bingner.com) or Apollo's (https://mcapollo.github.io/Public) repo
# Ascii Art from (http://patorjk.com/software/taag/) #
###########################################################################
validate_download_directory () {
if [[ -d $1 ]] && [[ -w $1 ]]
    then
        printf "Directory was Found and Writable\n\n"
    else
        printf "Error!!\n"
        printf "Directory WAS NOT Found or WAS NOT Writable.\n"
        create_missing_directory $1
fi
}    # check and create the directory if it doesnt exist
create_missing_directory () {
printf "Would you like to Create it? (y/n)\n"             #create Missing Directory
read -n 1 MK_DEFAULT_DIR
    case $MK_DEFAULT_DIR in
    n|N)
        printf "\nExiting...\n"
        exit 2
        ;;
    q|Q)
        echo
        exit 0
        ;;
    y|Y|*)
        mkdir -p $1
        printf "Directory Created\n"
        ;;
    esac
return 0
}       # Function to Create Missing Directory
set_download_location(){
printf "\n 1) Local\n"
printf " 2) Default\n"
printf " 3) Other\n"
read -n 1 D_PATH
    case $D_PATH in
    1)  DIR=$RUNPATH
        printf " \nThe Download Path is set to your current Directory\n";;
    3)  printf " \nDon't Use \"~\" in your Path or Place a trailing \"/\"\n"
        read -p 'Enter Download Path:   ' DIR;;
    2|*)  printf " \nThe Downloader's Path is \"$DIR\"\n";;
esac
}            # set download location
set_log_location () {
printf "Keep Log Location as Default? (Y/N)?    (default: /tmp)\n"
read -n 1 C_LOG_LOCATION
    case $C_LOG_LOCATION in
        n|N)
            echo ""
            read -p 'Enter Log Path:   ' LOG_LOCATION            # custom directory and check
            validate_download_directory $LOG_LOCATION
            LOG=$LOG_LOCATION/aria2c.log
            ;;
        q|Q)
            exit 0
            ;;
        y|Y|*)
            LOG_LOCATION=/tmp
            validate_download_directory $LOG_LOCATION
            LOG=$LOG_LOCATION/aria2c-"$(($RANDOM))".log
            ;;
    esac
}               # set aria's log location
download_http_final(){
case $1 in
    q|Q)
        exit 0
        ;;
    n|N)
        printf "\nEnter The New Filename: (Don't forget the Extension)\n"
        read CUSTOM_FNAME
        echo
        printf "Go Ahead with the Following:\n"
        echo "------------------------"
        printf "*URL: $URL\n"
        printf "*Download Location: $DIR\n"
        printf "*File Name: $CUSTOM_FNAME\n"
        printf "*File Allocation: $file_alloc\n"
        printf "*Max Threads: $THREADS\n"
        printf "*Max Connections: $MAX\n"
        printf "*Segment Size: $SEG\n"
        printf "*Log Location: $LOG\n"
        echo "------------------------"
        printf "*Extra Arguments: $ADV\n"
        echo "------------------------"
        printf "Press Enter to Continue\n"
        read ok
        $SET_ARIA2C -d $DIR -o "$CUSTOM_FNAME" -c -s $THREADS --file-allocation=$file_alloc -x $MAX -k $SEG "$ADV" "$URL" > $LOG 2>&1 &
        ;;
    y|Y|*)
        printf "\nNOTICE!!! \n\n   Didn't change The File Name\n\n"
        sleep 1         # sleep to notice the notice xD.
        echo "------------------------"
        printf "Go Ahead with the Following:\n"
        echo "------------------------"
        printf "*URL: $URL\n"
        printf "*Download Location: $DIR\n"
        printf "*File Allocation: $file_alloc\n"
        printf "*Max Threads: $THREADS\n"
        printf "*Max Connections: $MAX\n"
        printf "*Segment Size: $SEG\n"
        printf "*Log Location: $LOG\n"
        echo "------------------------"
        printf "*Extra Arguments: $ADV\n"
        echo "------------------------"
        printf "Press Enter to Continue\n"
        read ok
        if [[ $URLCHECK == "list" ]] || [[ $URLCHECK == "l" ]]                  # check if input is a list
            then
              $SET_ARIA2C -d $DIR -c -s $THREADS --file-allocation=$file_alloc -x $MAX -k $SEG "$ADV" -i "$URL" > $LOG 2>&1 &
            elif [[ $URLCHECK == "torrent" ]] || [[ $URLCHECK == "t" ]]
              then
                $SET_ARIA2C -d $DIR -c true -s $THREADS --file-allocation=$file_alloc -x $MAX -k $SEG "$ADV" -T "$URL" --listen-port=65500 --dht-listen-port=65400 -u 25 > $LOG 2>&1 &
            else
              $SET_ARIA2C -d $DIR -c -s $THREADS --file-allocation=$file_alloc -x $MAX -k $SEG "$ADV" "$URL" > $LOG 2>&1 &
      fi
        ;;
esac
}              # Function to Change Output Name
local_aria2c(){
local local_aria=$RUNPATH/aria2c
if [[ -f $local_aria ]] && [[ -x $local_aria ]]
    then
        SET_ARIA2C=$local_aria
fi
}                     # use aria2c from current folder if found
aria2c_check () {
if [[ -f $SET_ARIA2C ]] && [[ -x $SET_ARIA2C ]]             # Check if Binary Exists and Executable
    then
        if  [ -d $SET_ARIA2C ]      #check if only the directory was entered.
            then
                printf "\nError!!\n"
                printf "You Must Enter the Full Path to the Binary File\n"
                exit 10
        fi
    printf "A Binary was Found and it has Correct Permissions\n"
    else
        printf "\naria2c WAS NOT found or DOES NOT have correct Permissions\nExiting...\n"
        printf "Want to attempt to install it? (Y/N)\n"
        read -n 1 INSTALL_PROMPT
            case $INSTALL_PROMPT in
                y)  if [[ $ARIA2_OS == "cust" ]]
                            then
                                printf "\nWhat is your OS\n Enter one of the following\n"
                                printf "openwrt , ios , mac , win64 , win32 , android\n"
                                read ARIA2_OS
                            else
                                echo $ARIA2_OS
                    fi
                        auto_install_aria2 $ARIA2_OS
;;
                n|*)    printf "\nExiting...\n";exit;;
                esac
fi
}                   # check if the chosen aria2 is correct and install if it isn't
auto_install_aria2(){
case $1 in
    openwrt)
        printf "\ninstalling for OpenWRT\n"
        opkg update && opkg install aria2;
        exit;;
    ios)
        printf "\nYou Need the package \"Aria2\" from: \n"
        printf "Sam Bingner's (https://apt.bingner.com) or Apollo's (https://mcapollo.github.io/Public) repo\n"
        printf "To Get the Most Up-To-Date Features\n"
        printf "However, I can try to manually install it\n"
        printf "Proceed ?\n"
        read InstallforI
            case $InstallforI in
                n|N )
                    exit;;
                y|Y|*)
                    printf "installing Aria2\n"
                    TMP=$(mktemp -d)
                    wget -e robots=off -r -nc -np -nd -nH --accept-regex=aria2 -R 'index.html' https://apt.bingner.com/debs/1443.00/ -P $TMP && echo Downloaded
                    dpkg -i -R $TMP
                    rm -r $TMP
                    printf "\nDone\n"
                    exit;;
            esac
        ;;
    mac)
        printf "\nYou Need to have Homebrew installed\n"
        printf "\n 1) Homebrew is already installed, Install Aria2 Now \n 2) Install Homebrew, then Aria2\n Q) to Quit\n"
        read -n 1 STEP
            case $STEP in
                1)  printf "Installing..."
                    printf "\ninstalling for Mac via homebrew\n"
                    brew install aria2 && clear;exit;;
                2)  (/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)")&&(sh /$RUNPATH/$MYSCRIPT -u);exit;;
                q|*) exit;;
            esac
        ;;
    win64)
        printf "\nInstalling Aria2 for 64-bit Windows\n"
        printf "\nPress Enter to Continue\n"
        read ok
        TMP=$(mktemp -d)
        wget -e robots=off -r -nc -np -nd -nH --accept-regex=64bit -R 'latest' https://github.com/aria2/aria2/releases/latest -P $TMP && echo Downloaded
        unzip $TMP/aria2*
        mv $TMP/aria2*/aria2c.exe $RUNPATH
        rm -r $TMP;;
    win32)
        printf "\nInstalling Aria2 for 32-bit Windows\n"
        printf "\nPress Enter to Continue\n"
        read ok
        TMP=$(mktemp -d)
        wget -e robots=off -r -nc -np -nd -nH --accept-regex=32bit -R 'latest' https://github.com/aria2/aria2/releases/latest -P $TMP && echo Downloaded
        unzip $TMP/aria2*
        mv $TMP/aria2*/aria2c.exe $RUNPATH
        rm -r $TMP;;
    android)
        printf "\nInstalling Aria2 for Android\n"
        printf "\nPress Enter to Continue\n"
        read ok
        TMP=$(mktemp -d)
        wget -e robots=off -r -nc -np -nd -nH --accept-regex=android -R 'latest' https://github.com/aria2/aria2/releases/latest -P $TMP && echo Downloaded
        unzip $TMP/aria2*
        mv $TMP/aria2*/aria2c $RUNPATH
        rm -r $TMP;;
    *)  printf "\nExiting...\n";exit;;
esac

}               # Aria2 Installer
download_script(){
################### Start of Download Script ############################
  clear
  OPENWRT_LOGO
  echo
  echo "*************************"
  echo "* Aria2 Auto-Downloader *"
  echo "*************************"
  echo "Hi,"
  echo "Input a Download Link or type \"list\" for Download List location."
  echo "----------------"
  read -p 'Link= ' URLCHECK
    if [[ -z $URLCHECK ]]                                         # check if url is empty
        then
            printf "Input is Empty\n"
            exit
    fi
if [[ $URLCHECK == "list" ]] || [[ $URLCHECK == "l" ]]            # check if input is a list
    then
        printf "\nEnter a List Location/URL\n"
        read -p 'List = ' URL
                if [[ -z $URL ]]                                         # check if url is empty
                    then
                        printf "Input is Empty\n"
                        printf "Try Again\n"
                        exit
                fi
elif [[ $URLCHECK == "torrent" ]] || [[ $URLCHECK == "t" ]]; then
  printf "\nEnter a A Torrent's Location/URL\n"
  read -p 'Torrent = ' URL
          if [[ -z $URL ]]                                         # check if url is empty
              then
                  printf "Input is Empty\n"
                  printf "Try Again\n"
                  exit
          fi
  #statements
    else
        URL=$URLCHECK
fi

  ### Change output filename ###
  # set -x
  if [[ $URLCHECK == "list" ]] || [[ $URLCHECK == "l" ]]          # check if input is a list
      then
          download_http_final y
  elif [[ $URLCHECK == "torrent" ]] || [[ $URLCHECK == "t" ]]          # check if input is a torrent
        then
            printf "\nKeep Original Filename (Y/N)?\n"
            read -n 1 FNAME
            echo " "
            download_http_final $FNAME
    #statements
      else
        printf "\nKeep Original Filename (Y/N)?\n"
        read -n 1 FNAME
        echo " "
        download_http_final $FNAME
  fi

  printf "Initiating......\n"
  printf "The Download is in Progress\n"
  printf "\n  Note: if you chose \"Monitor\" you can't close this session\n"
  printf "  If You Choose to Background, a command will be provided so you can check the progress\n"
  printf "\nPress \"M\" to Monitor\nAny key to Background and Close\n"
  read -n1 INPUT
  case $INPUT in
    m|M)
    clear;printf "Monitoring....\n"
    tail -f $LOG
    ;;
    *)
    printf "\nBackgrounding.....\n"
    printf "To Stop Downloading use\n killall aria2c\n"
    printf "To Check Progress\n tail -f "$LOG"\n"
    sleep 1
    exit
    ;;
  esac
############ End of Aria2c Downloader Script#############
}     # set url or list as input
set_threads(){
    printf "\nSet Download Threads No.:  "
    read THREADS
}                      # Set a download's max threads
set_max_connections(){
    printf "\nSet Max Connections per Host (Max=16):"
    read MAX
}              # Set a download's max connections from same host
set_segment_size(){
    printf "\nSet Download Download Segment Size.(default 1M):  "
    read SEG
return 1
}                 # Set a download's max segment size
set_alloc(){
printf "\nSet File Allocation Method  "
printf "\nPossible Values: none, prealloc, trunc, falloc\n"
printf "Default value= none\n"
printf "for the default vaule Press Enter/Return\n"
read get_value
case $get_value in
trunc)
file_alloc=trunc
printf "\nYou Chose $file_alloc\n"
read ok;;
falloc)
file_alloc=falloc
printf "\nYou Chose $file_alloc\n"
read ok;;
prealloc)
file_alloc=prealloc
printf "\nYou Chose $file_alloc\n"
read ok;;
none|*)
file_alloc=none
printf "\nYou Chose $file_alloc\n"
read ok;;
esac
}                        # Choose Allocation method
adv_para(){
printf "\nSet Advanced Parameters:  \n"
read ADV
}                         # Enter Advanced parameters for Aria2
usage_adv(){
printf "\n\nYou Can either Run the script itself interactivly or via CLI\n"
echo $MYSCRIPT [option]
printf "\n\nOptions:\n"
echo "----------"
printf "\n -a       for advanced options. you can set thread count, max connections per host, segment size and file allocation method\n"
printf " -h         Shows this Usage Info\n"
printf " -o         Install Aria2 for OpenWRT\n"
printf " -d         Jump to OS Selector\n"
printf " -j         for passing more Aria2 paramters (ex. -j 1)\n\n"
printf " -k         To Kill Aria2's process\n"
}                        # Show usage info
os_select(){
case $1 in             # Start of OS Selector cases
    o|O)            # OpenWRT
        ARIA2_OS=openwrt
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
        local_aria2c        # use aria2c from local folder if found
        aria2c_check $SET_ARIA2C
        echo "Setting Work Directories"
        echo "Setting Download Directory"
        DIR=/mnt2/sda1/usb/video
        set_download_location
        validate_download_directory $DIR
        printf "Setting Log Directory\n"
        set_log_location
        printf "Download Loation: "$DIR"\n"
        printf "Log Location: "$LOG"\n"
        echo "Continuing..."
        ;;
    z|Z)                                                    # Custom Inputs
        clear
        ARIA2_OS=cust
        CUST_OS_LOGO(){
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
        }
        CUST_OS_LOGO
        read -p "Aria2c's Binary Location (Skip if locally):   " SET_ARIA2C
        local_aria2c        # use aria2c from local folder if found
        aria2c_check $SET_ARIA2C
        read -p 'Enter Download Path:   ' DIR                # custome directory and check
        validate_download_directory $DIR
        printf "Setting Log Directory\n"
        set_log_location
        printf "Download Loation: "$DIR"\n"
        printf "Log Location: "$LOG"\n"
        echo "Continuing..."
        ;;      #custom install case
        *)
        printf "\nYou Didn't Choose. Exiting...\n"
        exit 10
        ;;
    esac                # End of OS Selector cases
}           # sets the working directories required for the downloader.
#countdown()             #usage: countdown "00:00:05" #
#(
#IFS=:
#set -- $*
#secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
#while [ $secs -gt 0 ]
#    do
#    sleep 1 &
#    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
#    secs=$(( $secs - 1 ))
#    wait
#    done
#echo    #empty line
#echo message    # any command
#)
############################################################################
DOWNLOADER_ARIA2(){
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
printf " Press \"z\" to use Custom Download locations (ADVANCED)\n"
read -n 1 OS_Main
os_select $OS_Main
download_script
# End of DOWNLOADER_ARIA2
}       # Main Downloader script with OS Selector
############################################################################
########### Setting Fixed Variables ###############
MYSCRIPT=$(basename $0)                           #
RUNPATH="${0%/*}"                                 #
MAX=16                                            #
THREADS=16                                        #
SEG=1M                                            #
file_alloc=none                                   #
ADV="-j 1"                                        #
#source RUNPATH/syto203.sh                        #
###################################################
clear
##########################################################################
# parse CLI input
while getopts "aodjkh" OPTS; do
    case $OPTS in
        a)
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
        o)  auto_install_aria2 openwrt;;
        d)  os_select o
            download_script;;
        j)  adv_para;;
        k)  printf "\nAttempting to Kill Aria2c\n"
            killall aria2c && printf "\nAria2c Killed\n"
            exit;;
#        b) DOWNLOADER_ARIA2_TORRENT;;
        *|h)  usage_adv
            exit 1;;
    esac
done
shift $(($OPTIND - 1))              # End of CLI Parser
##########################################################################
echo "                 __         _______________  ________/\       ";
echo "  _________.__._/  |_  ____ \_____  \   _  \ \_____  )/ ______";
echo " /  ___<   |  |\   __\/  _ \ /  ____/  /_\  \  _(__  < /  ___/";
echo " \___ \ \___  | |  | (  <_> )       \  \_/   \/       \\___ \ ";
echo "/____  >/ ____| |__|  \____/\_______ \_____  /______  /____  >";
echo "     \/ \/                          \/     \/       \/     \/ ";

echo "      ________                      .__                    .___            ";
echo "      \______ \   ______  _  ______ |  |   _________     __| _/___________ ";
echo "       |    |  \ /  _ \ \/ \/ /    \|  |  /  _ \__  \   / __ |/ __ \_  __ \ ";
echo "       |    \`   (  <_> )     /   |  \  |_(  <_> ) __ \_/ /_/ \  ___/|  | \/";
echo "      /_______  /\____/ \/\_/|___|  /____/\____(____  /\____ |\___  >__|   ";
echo "              \/                  \/                \/      \/    \/       ";
sleep 1
#
printf "Welcome\n"
printf "Make Your Choice\n"
printf " \"D\" to Open Aria2 Downloader\n"
printf " \"A\" to Config Advanced Options\n"
printf " \"Q\" to Exit\n"
read -n 1 CHOICE
echo " "

case $CHOICE in                 # Main Case Selector
        d|D)            ################## Aria2c Downloader ####################
            DOWNLOADER_ARIA2     # calls out to DOWNLOADER_ARIA2 for use in Main Case Selector (should really find a better name)
            ;;              # End Of Main Case Selector Choice


        q|Q)
            printf "Exiting....\n\n"
            exit
            ;;
        a|A)                      # config extra options
            echo " "
            printf "Enabling Advanced Options. Restarting... \n"
            sh /$RUNPATH/$MYSCRIPT -a
            ;;

        *)                      # if you enter anything other than what's specified. Must be the last case
            echo " "
            printf "You Didn't Choose. Restarting... \n"
            sh /$RUNPATH/$MYSCRIPT
            ;;
        esac
