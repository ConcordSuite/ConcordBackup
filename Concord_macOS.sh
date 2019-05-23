#!/bin/bash
# Concord_macOS Version 1.3.1
# Created For The Liberty's IT Helpdesk For macOS backups
# Version 1.3.1 Update Highlights
# Re-adds a logging feature for the source drive

# Trap Command That Generates A SHA 256 Hash On The ScriptProgress Log When Ctrl_C Is Detected
# The Concord_macOSChecksum File Contains General Info For Debugging Like (Date/Time and OS Version)
trap ctrl_c INT
function ctrl_c()
{
clear && cd /
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
tput setaf 3; echo "Warning"
tput setaf 7; echo "Detected CTRL_C From $SUDO_USER"
echo "Script Was Stopped By $SUDO_USER Via CTRL_C" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
date -u | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
uname -a  | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
echo "Creating A SHA 256 Hash now" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
sleep 2
cd /
openssl dgst -sha256  Users/$SUDO_USER/Desktop/ScriptProgress.log | tee -a Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
chmod 444 Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
clear
tput setaf 2; echo "Successfully Created A SHA 256 Hash"
sleep 1
clear
tput setaf 7; echo "Exiting Script Now"
clear
exit 0
}

# This Function Makes Sure That The Script Is Running With Sudo Or Root
if [ "$EUID" -ne 0 ]
then cd / && tput setaf 3; echo "Can't Run Script With Non Sudo Rights!" && tput setaf 7; echo "Try Running sudo ./concord.sh " | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
exit
fi

# Allows Concord Scripts To Be Updated Via GitHub For Easy Update Management
# Finds The Scripts Location And Sets A Variable For That
clear && tput setaf 7; echo "Checking For New Updates Via Concord's Github" && sleep 2 && cd / | tee Users/$SUDO_USER/Desktop/ScriptProgress.log
ScriptLocation=$(cd "$(dirname "$0")"; pwd)
# Creates A Folder For Concord_Temp
cd / && cd Users/"$SUDO_USER"/Desktop && mkdir Concord_Temp && cd Concord_Temp
# Downloads A List Of The New Version Of ConcordBackup Script
clear && curl -L -o ConcordVersionList.txt https://raw.githubusercontent.com/ConcordSuite/ConcordBackup/master/ConcordVersionList.txt && clear && cd / | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
# Extracts The Link
URL=`sed -n 5p ConcordVersionList.txt`
clear
# Extracts Version Number From List
cd /
VersionNumberList=`sed -n 4p Users/"$SUDO_USER"/Desktop/Concord_Temp/ConcordVersionList.txt`
clear
# Extracts Version Number From Current Script
cd /
VersionNumberScript=`sed -n 2p "$ScriptLocation"/Concord_macOS.sh`
clear
# Compares The Versions To Determine If The Script Needs To Be Downloaded
if [ "$VersionNumberList" == "$VersionNumberScript" ]
  then
    tput setaf 2; echo "You Have The Lastest Version Of The Concord Backup" && sleep 2 | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
    cd / && rm -rf Users/"$SUDO_USER"/Desktop/Concord_Temp
    cd / && rm -rf Users/"$SUDO_USER"/Desktop/Concord_Temp/ConcordVersionList.txt
  else
    tput setaf 3; echo "Concord Version Out Of Date!!" && sleep 2 && tput setaf 7; echo "Downloading Newest Version From GitHub" && sleep 1 | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
    cd / && cd Users/"$SUDO_USER"/Desktop/Concord_Temp
    curl -L -o Concord_macOS.sh "$URL"
    clear && tput setaf 2; echo "Successfully Downloaded The Newest Version Of Concord" && sleep 2 | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
    tput setaf 7; echo "Adding Some Finishing Touchs, Please Wait" && sleep 2
    cd / && rm -f "$ScriptLocation"/Concord_macOS.sh
    cd / && rsync -av Users/"$SUDO_USER"/Desktop/Concord_Temp/Concord_macOS.sh "$ScriptLocation"
    cd / && chmod +x "$ScriptLocation"/Concord_macOS.sh
    cd / && rm -rf Users/"$SUDO_USER"/Desktop/Concord_Temp
    cd / && rm -rf Users/"$SUDO_USER"/Desktop/Concord_Temp/ConcordVersionList.txt
    clear && tput setaf 3; echo "Please Re-run Script" && sleep 2 && exit 0
fi

# The Start Of The Script For The User
cd /
tput setaf 7; clear && echo Running Concord v1.3.1 | tee Users/$SUDO_USER/Desktop/ScriptProgress.log
sleep 2
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
# Puts The Date/Time Of When The Script Was Started On The ScriptProgress Log
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
echo "When Concord Was Started On By $SUDO_USER (UTC Formatted)" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
date -u | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
# Acknowledges That The User Is Using This Only On macOS (The Script Will Also Check For The OS Version To Double Check)
clear && tput setaf 3; echo This Script Only Runs On macOS And Not General Linux Distros Like Ubuntu Yet
read -n 1 -s -r -p "Press any key to continue"
clear
uname -a  | grep 'Darwin Kernel Version' &> /dev/null
if [ $? == 0 ]; then
        tput setaf 2; echo "Successfully Verfied macOS Is Installed, Contining Script" && sleep 2 && cd / | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
      fi

# Adds The OS Version Of The Host To ScriptProgress Log
clear && echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
clear && echo "The OS Version The Host Is Running" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
uname -a | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
clear && echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log

# Creates A List Of Current Mounted Drives Of The System For The Source
clear && tput setaf 7; echo "Scanning For Any Mounted Drives"
clear && sleep 1
tput setaf 6; echo  "Current Mounted Drive List On Local Machine"
echo "Please Type In The Correct Drive Name You Want To Use As The Source Drive"
echo "Ex: Macintosh HD Would Be A Valid Name"
echo '' && cd /
tput setaf 7; diskutil list | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
echo -n 'SourceDrive: '
read "SourceDrive"
cd /
clear && echo "You Have Selected "$SourceDrive"" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log Users/$SUDO_USER/Desktop/Concord_macOSChecksum.log
sleep 2 && clear

# Scans The Drive For A Certain Folder So The Backup Will Know If macOS Installed Or Windows Installed
cd /
if [ -d "Volumes"/"$SourceDrive"/"Windows" ]; then
               clear && tput setaf 2; echo "Found Windows Installed!" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
               sleep 1 && SourceDrivePath=Volumes/"$SourceDrive"/Users
               clear && tput setaf 7
            fi

if [ -d "Volumes"/"$SourceDrive"/"Library" ]; then
                clear && tput setaf 2; echo "Found macOS Installed!" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                sleep 1 && SourceDrivePath=Volumes/"$SourceDrive"/Users
                clear && tput setaf 7
            fi

# Allows The User To Choose The Profile That They Want To Backup
tput setaf 6; echo "What User Profile Would You Like To Backup?"
cd / && cd "$SourceDrivePath"
tput setaf 7; ls
echo -n 'Profile: '
read Profile

# Adds The Profile That The User Selected To The Log File
cd / && clear
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
echo "$SUDO_USER Selected "$Profile" For The Profile To Be Backed Up" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
clear

# Makes Sure That The User Selected The Right Profile For The Source Backup Profile
tput setaf 6; echo "Now Verfying Profile Exists" && sleep 2 && clear
cd /
tput setaf 1; [ ! -d "$SourceDrivePath"/"$Profile" ] && clear && echo "Could Not Find Profile, Please Try Again" && exit | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
tput setaf 2; clear && echo "Successfully Verified User Profile" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
sleep 2 && clear

# Adds A Line For The Incoming Folder Size In ScriptProgress Logging
echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
echo "Here's The Estimated Folder Sizes For The Backup" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
clear

# Scans The Profile Of A Estimated Size Of The Profile By Using du
tput setaf 6; echo "Scanning Profile Now, Please Wait"
echo ''
cd / && tput setaf 7; du -skh "$SourceDrivePath"/"$Profile"/*/ | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
echo ''
tput setaf 2; echo "Finished Scanning Profile"
tput setaf 7; read -n 1 -s -r -p "Press any key to continue"

# Allows The User To Select The Destination Drive Type So The Script Will Know If It Needs To Mount A Network SMB Drive Or Use A Local Mounted Drive
clear && tput setaf 6; echo "Please Select Your Destination Drive"
cd / && tput setaf 7;
PS3='Destination Drive Type '
options=("Network SMB Share (fs3.liberty.edu\hdbackups)" "Local Mounted Drive" )
select opt in "${options[@]}"
do
    case $opt in
# The Network SMB Share Portion Of The Destination Drive Script
# This Uses A AppleScript Command To Mount The SMB Share For Sercurity And For Simple Usage
# This Also Uses A Variable For The Mounted Drive Path For Simple Usage
        "Network SMB Share (fs3.liberty.edu\hdbackups)")
                  echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                  echo "$SUDO_USER Selected Network SMB Share, Mounting fs3.liberty.edu\hdbackups" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                  clear && tput setaf 6; echo "Now Mounting fs3.liberty.edu\hdbackups"
                  sleep 1
                  osascript -e 'mount volume "smb://fs3.liberty.edu/hdbackups"'
                  end tell
                  clear && Destination="volumes/hdbackups/backups"
                  cd / && tput setaf 1; [ ! -d $Destination ] && clear && echo "Could Not Mount fs3.liberty.edu\hdbackups, Please Try Again" && exit | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                  tput setaf 2; echo "Successfully Mounted HDbackups" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                  sleep 2 && tput setaf 7
            ;;
# The Local Mounted Drive Portion Of The Script
# This Will Allow The User To Pick A Local Drive To Back Up To
# This Also Uses A Variable For The Mounted Drive Path For Simple Usage
        "Local Mounted Drive")
              echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
              echo "$SUDO_USER Selected Local Mounted Drive, Waiting For The User To Select A Destination Drive" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
              clear && tput setaf 7; echo Scanning For Any Mounted Drivess
              sleep 1
              clear && tput setaf 6; echo  "Current Mounted Drive List"
              echo "Please Type In The Correct Drive Name You Want To Use As The Destination Drive"
              echo "Ex: Macintosh HD Would Be A Valid Name"
              echo ''
              tput setaf 7; diskutil list | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
              echo -n 'DestinationDrive: '
              read "DestinationDrive"
              clear && Destination= "volumes/"$DestinationDrive""
              echo You Have Selected "$DestinationDrive" && sleep 1 | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
              echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
              cd / && cd "$Destination"
            ;;
# When The User Doesn't Select A Correct Destination Drive Type....
            *)  echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                tput setaf 1; clear && echo "Invalid Option, Exiting Script lol" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                tput setaf 7; echo "You Selected ($REPLY)" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
                echo "You Had One Job Buddy But You Failed, Select One From The List Next Time"
                break;;
    esac

# Makes The User Type In The CS Number For The Backup And Creates A Variable For The CS Number For Simple Usage
          clear && echo "Please Enter The CS Number"
          echo -n 'CS: '
            read CS
            echo "User Entered "$CS" For The CS Number" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
            echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
            cd /

# Creates The Backup Folder With The CS Number On The Destination Path
              cd / && mkdir "$Destination"/"$CS"
              echo "Successfully Created A $CS Folder On ""$Destination" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
              cd / && mkdir "$Destination"/"$CS"/"$Profile"
              echo "Successfully Created A $Profile Labeled Folder On "$Destination"/""$CS/" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
              clear
              echo '' | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log

# Allows The Script To Access The User's Folder
          clear && echo "Allowing Read And Write Access For The Folders That Need To Be Backup"
          cd / && sleep 1
          chmod -R 777 "$SourceDrivePath"/"$Profile"
          echo "Successfully Chmod 755 "$Profile"'s Profile" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
          echo '' | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
          clear && echo Now Backing Up "$SourceDrivePath"/"$Profile" "" To "$Destination"/"$CS"/"$Profile" | tee -a Users/$SUDO_USER/Desktop/ScriptProgress.log
          sleep 1

# The Windows Backup Part Using Rsync To Backup Certain Folders On The Source Drive
          if [ -d Volumes/"$SourceDrive"/Windows ]; then
                        cd /
                        clear && echo "Backing Up $Profile's Desktop"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Desktop "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Downloads"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Downloads "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Documents"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Documents "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Videos"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Videos "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Pictures"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Pictures "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Music"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Music "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profiles's Browser Bookmarks"
                        rsync -azh "$SourceDrivePath"/"$Profile"/AppData/Roaming/Mozilla/Firefox/Profiles/*/places.sqlite "$Destination"/"$CS"/"$Profile"
                        rsync -azh "$SourceDrivePath"/"$Profile"/AppData/Local/Google/Chrome/"User Data"/Default/Bookmarks "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Sticky Notes"
                        rsync -azh "$SourceDrivePath"/"$Profile"/AppData/Roaming/Microsoft/Signatures/ "$Destination"/"$CS"/"$Profile"
                        clear && tput setaf 2; echo "Successfully Copied "$Profile" To "$Destination"" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        sleep 3 && clear
                        tput setaf 6; echo "Now Verfying Backup Size And Counting Files That Were Backed Up" && sleep 2
                        clear && echo '' | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
# Where The Data Backup Is Verified Via A File Count And Backup Size Count
                        tput setaf 2; echo "The Final Backup Data Size On "$Destination"/"$CS"/"$Profile" Is" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && du -hd1 "$Destination"/"$CS"/ | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && echo '' | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        echo "The Final Destination And Source File Count Is" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && echo "Destination File Count" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && cd "$Destination"/"$CS"/"$Profile"
                        DestinationFiles=`ls Desktop Documents Downloads Videos Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                        cd / && echo "$DestinationFiles" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && echo "Source File Count" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && cd "$SourceDrivePath"/"$Profile"
                        SourceFiles=`ls Desktop Documents Downloads Videos Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                        cd / && echo "$SourceFiles" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        echo ''
                        read -n 1 -s -r -p "Press any key to continue"
                        clear
                        echo "Copying ScriptProgress.log To "$Destination"/"$CS"/"$Profile""
                        cd / && rsync -azh Users/"$SUDO_USER"/Desktop/ScriptProgress.log "$Destination"/"$CS"
                        clear && echo "Thank You For Running Concord v1.2"
                        sleep 3 && exit 0
                      fi

# The macOS Backup Part Using Rsync To Backup Certain Folders On The Source Drive
            if [ -d Volumes/"$SourceDrive"/Library ]; then
                        cd /
                        clear && echo "Backing Up $Profile's Desktop"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Desktop "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Downloads"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Downloads "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Documents"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Documents "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Movies"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Movies "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Pictures"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Pictures "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Music"
                        rsync -azh --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Music "$Destination"/"$CS"/"$Profile"
                        clear && tput setaf 2; echo "Successfully Copied "$Profile" To ""$Destination" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        sleep 3 && clear
                        tput setaf 6; echo "Now Verfying Backup Size And Counting Files That Were Backed Up" && sleep 2
                        clear && echo '' | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
# Where The Data Backup Is Verified Via A File Count And Backup Size Count
                        tput setaf 7; echo "The Final Backup Data Size On "$Destination"/"$CS"/"$Profile" Is" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && du -hd1 "$Destination"/"$CS"/ | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && echo '' | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        echo "The Final Destination And Source File Count Is" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && echo "Destination File Count" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && cd "$Destination"/"$CS"/"$Profile"
                        DestinationFiles=`ls Desktop Documents Downloads Movies Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                        cd / && echo "$DestinationFiles" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && echo "Source File Count" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        cd / && cd "$SourceDrivePath"/"$Profile"
                        SourceFiles=`ls Desktop Documents Downloads Movies Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                        cd / && echo "$SourceFiles" | tee -a Users/"$SUDO_USER"/Desktop/ScriptProgress.log
                        echo ''
                        read -n 1 -s -r -p "Press any key to continue"
                        clear
                        echo "Copying ScriptProgress.log To "$Destination"/"$CS"/"$Profile""
                        cd / && rsync -azh Users/"$SUDO_USER"/Desktop/ScriptProgress.log "$Destination"/"$CS"
                        clear && echo "Thank You For Running Concord v1.2"
                        sleep 3 && exit 0
                      fi
done
