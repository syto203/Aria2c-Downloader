#!/bin/sh

#  syto203.sh
#  
#
#  Functions Created by syto203 on 6/30/19.
#  
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

#Function to Create Missing Directory
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
q|Q)
exit 0
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
q|Q)
exit 0
;;
y|Y|*)
LOG_LOCATION=/tmp
validate_download_directory $LOG_LOCATION
LOG=$LOG_LOCATION/aria2c.log
;;
esac
}

#Function to Change Output Name
download_http_final (){
case $1 in
q|Q)
exit 0
;;
n|N)
echo "Enter Filename: (Don't forget the Extension)"
read CUSTOM_FNAME
echo "The Following will now Run."
echo "--****------****----****------****----****------****----****------****----****------****--"
echo "Path+filename-˯     Threads     Max Conn.     Segment Size      Log Location          "
echo "aria2c "-d" "$DIR ""-o" "$CUSTOM_FNAME " -c "-s" "$THREADS" "--file-allocation=""$file_alloc" "-x" "$MAX" "-k" "$SEG" "$URL "> "$LOG" 2>&1 &"
echo "--****------****----****------****----****------****----****------****----****------****--"
echo "Press Enter to Continue"
read ok
$SET_ARIA2C -d $DIR -o $CUSTOM_FNAME -c -s $THREADS --file-allocation=$file_alloc -x $MAX -k $SEG "$URL" > $LOG 2>&1 &
;;
y|Y|*)
printf "NOTICE!!!   Didn't change The File Name\n\n"
echo "The Following will now Run."
echo "--****------****----****------****----****------****----****------****----****------****--"
echo "Path+filename-˯     Threads     Max Conn.     Segment Size      Log Location          "
echo "aria2c "-d" "$DIR " -c "-s" "$THREADS" "--file-allocation=""$file_alloc" "-x" "$MAX" "-k" "$SEG" "$URL "> "$LOG" 2>&1 &"
echo "--****------****----****------****----****------****----****------****----****------****--"
echo "Press Enter to Continue"
read ok
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
printf "Want to attempt to install it? (Y/N)\n"
read -n 1 INSTALL_PROMPT
case $INSTALL_PROMPT in
y)
case $OS in
openwrt)
sh /$RUNPATH/$MYSCRIPT -o
;;
ios)
printf "installing Aria2\n"
TMP=$(mktemp -d)
wget -e robots=off -r -nc -np -nd -nH --accept-regex=aria2 -R 'index.html' https://apt.bingner.com/debs/1443.00/ -P $TMP && echo Downloaded
dpkg -i -R $TMP
rm -r $TMP
printf "\nDone\n"
;;
mac)
sh /$RUNPATH/$MYSCRIPT -u
;;
esac
;;
n|*)
printf "Exiting...\n"
exit
;;
esac

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
none )
file_alloc=none
printf "\nYou Chose $file_alloc\n"
read -t 1 ok
;;
trunc )
file_alloc=trunc
printf "\nYou Chose $file_alloc\n"
read -t 1 ok
;;
falloc )
file_alloc=falloc
printf "\nYou Chose $file_alloc\n"
read -t 1 ok
;;
prealloc|* )
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
