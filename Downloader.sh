#!/bin/bash
###########################################################################
# Dependancies
# assuming you have a functioning storage
# opkg install aria2
###########################################################################
#echo "** To-Do **"
#echo "1-Running from current directory with aria2c in same path."
#echo "2-Set the download and log to current path"
#echo "3-Pass options via cli"
#echo "4-Pre-set download locations to choose from"
#printf  "5-Search for aria2c and use it wherever it is.\n\n\n\n"
############################################################################
########### Setting Fixed Variables ###############
SCRIPTNAME=$(basename $0)                         #
SCRIPTPATH="${0%/*}"                              #
MAX=16                                            #
THREADS=16                                        #
SEG=1M                                            #
###################################################
#   Ascii Art using (http://patorjk.com) #
clear
echo "                 __         _______________  ________/\       ";
echo "  _________.__._/  |_  ____ \_____  \   _  \ \_____  )/ ______";
echo " /  ___<   |  |\   __\/  _ \ /  ____/  /_\  \  _(__  < /  ___/";
echo " \___ \ \___  | |  | (  <_> )       \  \_/   \/       \\___ \ ";
echo "/____  >/ ____| |__|  \____/\_______ \_____  /______  /____  >";
echo "     \/ \/                          \/     \/       \/     \/ ";
#
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
printf " ""P"" to Purge pagecache\n"
printf " ""D"" to Download using Aria2\n"
printf " ""M"" to start MiniDLNA Service Manager\n"
printf " ""Q"" to Exit\n"
read -n 1 CHOICE
echo " "

case $CHOICE in
        p|P)                # Memory Manager
                clear
                printf "\n***************************\n"
                printf "* MiniDLNA Service Manager *\n"
                printf "***************************\n\n"
                printf " How Can I Help You Today\n"
                printf "---------------.\n"
                printf "Press ""C"" For Combo Choice\n"
                printf "Press ""F"" to Check Current Memory\n"
                printf "Press ""P"" For Droping pagecache\n"
                read -n 1 INPUT
                    case $INPUT in
                            c|C)            # Combo Choice
                            ################## pagecache clearer ####################
                            printf " "
                            printf "Purging...\n"
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
                                printf "Purging...\n"
                                echo 1 > /proc/sys/vm/drop_caches
                            ;;
                    esac
                            ################## End of pagecache clearer ####################

        ;;
        d|D)            ################## Aria2c Downloader ####################
                clear
                echo "Opening Downloader"
                echo "Checking Aria2 installation and Permissions"
                sleep 1
####################################### aria2c's defaults #################################
#SET_ARIA2C=/usr/bin/aria2c                        # Default for OpenWRT and iOS
#SET_ARIA2C=/usr/local/bin/aria2c                 # Default for MacOS via homebrew (brew install aria2
#######################################################################################################
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
                    case $OS in

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
                                ## Prompt to changer Download Directory
                                printf "Keep Download path as Default? (Y/N)?\n"
                                printf "Default: /mnt/sda1/usb/video\n"
                                    read -n 1 C_DIR
                                        case $C_DIR in
                                            n|N)
                                                echo ""
                                                read -p 'Enter Download Path:   ' DIR       # custom directory and check
#mkdir -p $DIR                               # create the directory if it doesnt exist.
                                                    if [ -d $DIR ] && [ -w $DIR ]
                                                    then
                                                        printf "Directory was Found and Writable\n"
                                                    else
                                                        printf "Error!!\n"
                                                        printf "Directory WAS NOT Found or WAS NOT Writable.\nExiting...\n"
                                                        exit 2
                                                    fi
                                            ;;
                                            y|Y|*)

                                                printf "Keeping Default Download Path.\n"
                                                    DIR=/mnt/sda1/usb/video
                                                    if [ -d $DIR ] && [ -w $DIR ]
                                                        then
                                                            printf "Default Directory was Found and Writable\n\n"
                                                        else
                                                            printf "Error!!\n"
                                                            printf "Default Directory WAS NOT Found or WAS NOT Writable.\n"
                                                            printf "Would you like to Create it? (y/n)\n"             #create Missing Directory
                                                                read -n 1 MK_DEFAULT_DIR
                                                                    case $MK_DEFAULT_DIR in
                                                                        n|N)
                                                                            printf "\nExiting...\n"
                                                                            exit 2
                                                                        ;;
                                                                        y|Y|*)
                                                                            mkdir -p $DIR
                                                                            printf "Created Directory\n"
                                                                        ;;
                                                                    esac
                                                    fi
                                            ;;
                                        esac

                                printf "Setting Log Directory\n"
                                ## Prompt to changer Log Directory
                                printf "Keep Log Location as Default? (Y/N)?\n"
                                printf "Default: /tmp \n"
                                read -n 1 C_LOG_LOCATION
                                    case $C_LOG_LOCATION in
                                        n|N)
                                            echo ""
                                            read -p 'Enter Log Path:   ' LOG_LOCATION            # custom directory and check
                                            mkdir -p $LOG_LOCATION                              # create the directory if it doesnt exist.
                                                if [ -d $LOG_LOCATION ] && [ -w $LOG_LOCATION ]
                                                    then
                                                        printf "\nLocation was Found and Writable\n"
                                                        LOG=$LOG_LOCATION/aria2c.log
                                                    else
                                                        printf "Error!!\n"
                                                        printf "Log Location WAS NOT Found or WAS NOT Writable.\nExiting...\n"
                                                        exit 2
                                                fi
                                            ;;
                                        y|Y|*)
                                            LOG_LOCATION=/tmp
                                            printf "\nKeeping Default Log Path.\n"
                                                if [ -d $LOG_LOCATION ] && [ -w $LOG_LOCATION ]
                                                    then
                                                        printf "Location was Found and Writable\n"
                                                        touch $LOG_LOCATION/aria2c.log
                                                        LOG=$LOG_LOCATION/aria2c.log
                                                    else
                                                        printf "Error!!\n"
                                                        printf "\nLocation WAS NOT Found or WAS NOT Writable.\n"
                                                        printf "Would you like to Create it? (y/n)"             #create Missing Directory
                                                            read -n 1 MK_DEFAULT_DIR
                                                                case $MK_DEFAULT_DIR in
                                                                    n|N)
                                                                        printf "Exiting...\n"
                                                                        exit 2
                                                                        ;;
                                                                    y|Y|*)
                                                                        mkdir -p $LOG_LOCATION
                                                                        printf "Created Directory\n"
                                                                        touch $LOG_LOCATION/aria2c.log
                                                                        LOG=$LOG_LOCATION/aria2c.log
                                                                        ;;
                                                                esac
                                                fi
                                            ;;
                                    esac

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
                                ## Prompt to changer Download Directory
                                printf "Keep Download path as Default? (Y/N)?\n"
                                printf "Default: /var/mobile/Downloads/video \n"
                                read -n 1 C_DIR
                                        case $C_DIR in
                                            n|N)
                                                echo ""
                                                read -p 'Enter Download Path:   ' DIR       # custom directory and check
                                                #mkdir -p $DIR                               # create the directory if it doesnt exist.
                                                    if [ -d $DIR ] && [ -w $DIR ]
                                                        then
                                                            printf "Directory was Found and Writable\n"
                                                        else
                                                            printf "Error!!\n"
                                                            printf "Directory WAS NOT Found or WAS NOT Writable.\nExiting...\n"
                                                            exit 2
                                                    fi
                                                ;;
                                            y|Y|*)
                                                    printf "Keeping Default Download Path.\n"
                                                    DIR=/var/mobile/Downloads/video
                                                        if [ -d $DIR ] && [ -w $DIR ]
                                                            then
                                                                printf "Default Directory was Found and Writable\n\n"
                                                            else
                                                                printf "Error!!\n"
                                                                printf "Default Directory WAS NOT Found or WAS NOT Writable.\n"
                                                                printf "Would you like to Create it? (y/n)\n"             #create Missing Directory
                                                                read -n 1 MK_DEFAULT_DIR
                                                                    case $MK_DEFAULT_DIR in
                                                                        n|N)
                                                                            printf "\nExiting...\n"
                                                                            exit 2
                                                                            ;;
                                                                        y|Y|*)
                                                                            mkdir -p $DIR
                                                                            printf "Created Directory\n"
                                                                            ;;
                                                                    esac
                                                        fi
                                                ;;
                                        esac

                                    printf "Setting Log Directory\n"
                                    ## Prompt to changer Log Directory
                                    printf "Keep Log Location as Default? (Y/N)?\n"
                                    printf "Default: /tmp \n"
                                    read -n 1 C_LOG_LOCATION
                                        case $C_LOG_LOCATION in
                                            n|N)
                                                echo ""
                                                read -p 'Enter Log Path:   ' LOG_LOCATION            # custom directory and check
                                                mkdir -p $LOG_LOCATION                              # create the directory if it doesnt exist.
                                                if [ -d $LOG_LOCATION ] && [ -w $LOG_LOCATION ]
                                                    then
                                                        printf "\nLocation was Found and Writable\n"
                                                        LOG=$LOG_LOCATION/aria2c.log
                                                    else
                                                        printf "Error!!\n"
                                                        printf "Log Location WAS NOT Found or WAS NOT Writable.\nExiting...\n"
                                                        exit 2
                                                fi
                                                ;;
                                            y|Y|*)
                                                LOG_LOCATION=/tmp
                                                printf "\nKeeping Default Log Path.\n"
                                                if [ -d $LOG_LOCATION ] && [ -w $LOG_LOCATION ]
                                                    then
                                                        printf "Location was Found and Writable\n"
                                                        touch $LOG_LOCATION/aria2c.log
                                                        LOG=$LOG_LOCATION/aria2c.log
                                                    else
                                                        printf "Error!!\n"
                                                        printf "\nLocation WAS NOT Found or WAS NOT Writable.\n"
                                                        printf "Would you like to Create it? (y/n)"             #create Missing Directory
                                                        read -n 1 MK_DEFAULT_DIR
                                                            case $MK_DEFAULT_DIR in
                                                                n|N)
                                                                    printf "Exiting...\n"
                                                                    exit 2
                                                                    ;;
                                                                y|Y|*)
                                                                    mkdir -p $LOG_LOCATION
                                                                    printf "Created Directory\n"
                                                                    touch $LOG_LOCATION/aria2c.log
                                                                    LOG=$LOG_LOCATION/aria2c.log
                                                                    ;;
                                                            esac
                                                fi
                                                ;;
                                        esac

                                printf "Download Loation: "$DIR"\n"
                                printf "Log Location: "$LOG"\n"
                                touch /tmp/.aria2c
                                CHECK1=/tmp/.aria2c
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
                                if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]                             # check binary existance and executable permissions.
                                    then
                                        printf "A Binary was Found and it has Correct Permissions\n"
                                    else
                                        printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
                                        exit 1
                                fi
                                echo "aria2c has correct permissions"
                                echo "Setting Working Directories"
                                DIR=~/Downloads/
                                mkdir -p ~/Documents/aria2/
                                LOG=/tmp/aria2c.log
                                echo "Download Location= "$DIR""
                                echo "Log Location= "$LOG""
                                touch /tmp/.aria2c
                                echo "Continuing..."
                                sleep 1
read ok
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
                                            if [ -f $SET_ARIA2C ] && [ -x $SET_ARIA2C ]
                                                then
                                                        if  [ -d $SET_ARIA2C ]      #check if only the directory was entered.
                                                        then
                                                        print "\nError!!\n"
                                                        printf "You Must Enter the Full Path to the Binary File\n"
                                                        exit 10
                                                        fi
                                                    printf "A Binary was Found and it has Correct Permissions\n"
                                                else
                                                    printf "aria2c WAS NOT found or DOES NOT have correct permissions\nExiting...\n"
                                                    exit 11
                                            fi
                                read -p 'Enter Download Path:   ' DIR                # custome directory and check
                                            if [ -d $DIR ] && [ -w $DIR ]
                                                then
                                                    printf "Directory was Found and Writable\n"
                                                else
                                                    printf "Directory WAS NOT Found or WAS NOT Writable.\nExiting...\n"
                                                    exit 12
                                            fi
                                read -p ' Custom log path? (y/n) ' -n 1 SET_LOG
                                echo " "
                                    case $SET_LOG in
                                        y|Y)
                                            read -p 'Enter log path:   ' LOG_LOCATION
                                            echo " "
                                            if [ -d $LOG_LOCATION ] && [ -w $LOG_LOCATION ]
                                                then
                                                    printf "Directory was Found and Writable\n"
                                                    sleep 1
                                                    touch $LOG_LOCATION/aria2c.log
                                                    LOG=$LOG_LOCATION/aria2c.log
                                                else
                                                    printf "Directory WAS NOT Found or WAS NOT Writable.\nExiting...\n"
                                                    exit 13
                                            fi
                                            ;;
                                        n|N)
                                            printf "Using Default Path\n"
                                            LOG=/tmp/aria2c.log
                                            ;;
                                        *)
                                            echo " "
                                            printf "You Didn't Choose.\n"
                                            printf "Using Default Log Path\n"
                                            sleep 1
                                            LOG=/tmp/aria2c.log
                                            ;;
                                            esac
                                touch /tmp/.aria2c
                                CHECK1=/tmp/.aria2c
                                ;;
                        *)
                                echo " "
                                printf "You Didn't Choose. Exiting...\n"
                                exit 10
                                ;;
                                esac

#########################################################################
################### Start of Download Script ############################
#########################################################################
clear
sleep 1
#
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
sleep 1
#####################################
echo "--****------****--"
##########################################################################
# *Extra Options* (comment out the fixed variables first)
# read -p 'Threads =    (smaller or equal to max connections)' THREADS
# read -p 'Max Connections=    (bigger or equal to max connections)' MAX
# read -p 'Log Location=     ' LOG
# reap -p 'Segment Size=     ' SEGMENT
##########################################################################
            echo "The Following will now Run."
            echo "--****------****----****------****----****------****----****------****----****------****--"
            echo "        Path-˯     Threads     Max Conn.     Segment Size      Log Location          "
            echo "aria2c "-d" "$DIR " -c -s "$THREADS" -x "$MAX" -k "$SEG" "$URL "> "$LOG" 2>&1 &"
            echo "--****------****----****------****----****------****----****------****----****------****--"
### Change output filename ###
read -p 'Keep Original Filename (Y/N)?' -n 1 FNAME
echo " "
    case $FNAME in
        y|Y)
            echo "Enter Filename: (Don't forget the Extension)"
            read OFNAME
            echo "The Following will now Run."
            echo "--****------****----****------****----****------****----****------****----****------****--"
            echo "Path+filename-˯     Threads     Max Conn.     Segment Size      Log Location          "
            echo "aria2c "-d" "$DIR ""-o" "$OFNAME " -c "-s" "$THREADS" "-x" "$MAX" "-k" "$SEG" "$URL "> "$LOG" 2>&1 &"
            echo "--****------****----****------****----****------****----****------****----****------****--"
            echo "Press Enter to Continue"
            read ok
            $SET_ARIA2C -d $DIR -o $OFNAME -c -s $THREADS -x $MAX -k $SEG "$URL" > $LOG 2>&1 &
            ;;
        n|N)
            echo "Didnt change Name"
            $SET_ARIA2C -d $DIR -c -s $THREADS -x $MAX -k $SEG "$URL" > $LOG 2>&1 &
            ;;
        *)
            echo "Didnt change Name"
            $SET_ARIA2C -d $DIR -c -s $THREADS -x $MAX -k $SEG "$URL" > $LOG 2>&1 &
            ;;
    esac
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

        *)                      # if you enter anything other than what's specified. Must be the last case
            echo " "
            printf "You Didn't Choose. Restarting... \n"
            sh /$SCRIPTPATH/$SCRIPTNAME
            ;;


        esac
