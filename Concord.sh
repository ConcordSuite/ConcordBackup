#!/bin/bash
# Concord Version 1.5
# Created For The Liberty's IT Helpdesk For macOS backups
# Version 1.5 Update Highlights

# Added Native Linux Support (Ubuntu Has Been Tested, Debian Will Be Tested Soon) To The Script
# Adjusted Variables To Work With Ubuntu And macOS
# Removed CTRL-C Trap Command
# Updated Network SMB Share Section To Work With Linux and macOS
# Cleaned Up Code
# Added Browser Bookmark Rsync Backup Lines For macOS
# Added Bookmark Folder For Organization
# Prep Script For Concord Data Restore Feature (Coming Soon...)

# Detects What OS The User Is Using
# This Will Allow The Script To Create The Correct Variable Locations
clear && cd /
      if [ -d "Volumes" ]; then
                clear && tput setaf 2; echo "You Must Be Using macOS, Cool.... Adjusting Variables For Script"
                sleep 3 && clear
                LogFile=Users/"$SUDO_USER"/Desktop/ConcordLog.txt
                ChecksumFile=Users/"$SUDO_USER"/Desktop/ConcordChecksum.txt
                DriveFolder=Volumes
                clear && tput setaf 7
            fi
      if [ -d "media" ]; then
                clear && tput setaf 2; echo "You Must Be Using Some Kinda Of Linux Right?.... Adjusting Variables For Script"
                sleep 3 && clear
                LogFile=home/"$SUDO_USER"/Desktop/ConcordLog.txt
                ChecksumFile=home/"$SUDO_USER"/Desktop/ConcordChecksum.txt
                DriveFolder=media/"$SUDO_USER"
                clear && tput setaf 7
            fi

# This Function Makes Sure That The Script Is Running With Sudo Or Root
if [ "$EUID" -ne 0 ]
then cd / && tput setaf 3; echo "Can't Run Script With Non Sudo Rights!" && tput setaf 7; echo "Try Running sudo ./concord.sh " | tee -a "$LogFile"
exit
fi

# Update Portion Of Concord
# Allows Concord Scripts To Be Updated Via GitHub For Easy Update Management
# Finds The Scripts Location And Sets A Variable For That
clear && tput setaf 7; echo "Checking For New Updates Via Concord's Github" && sleep 2 && cd / | tee $LogFile
ScriptLocation=$(cd "$(dirname "$0")"; pwd)
# Creates A Folder For Concord_Temp
cd / && cd "$UserLocation" && mkdir Concord_Temp && cd Concord_Temp
# Downloads A List Of The New Version Of ConcordBackup Script
clear && curl -L -o ConcordVersionList.txt https://raw.githubusercontent.com/ConcordSuite/ConcordBackup/master/ConcordVersionList.txt && clear && cd / | tee -a $LogFile
# Extracts The Link
URL=`sed -n 5p ConcordVersionList.txt`
clear
# Extracts Version Number From List
cd /
VersionNumberList=`sed -n 4p "$UserLocation"/Concord_Temp/ConcordVersionList.txt`
clear
# Extracts Version Number From Current Script
cd /
VersionNumberScript=`sed -n 2p "$ScriptLocation"/Concord.sh`
clear
# Compares The Versions To Determine If The Script Needs To Be Downloaded
if [ "$VersionNumberList" == "$VersionNumberScript" ]
  then
    tput setaf 2; echo "You Have The Lastest Version Of The Concord Backup" && sleep 2 | tee -a $LogFile
    cd / && rm -rf "$UserLocation"/Concord_Temp
    cd / && rm -rf "$UserLocation"/Concord_Temp/ConcordVersionList.txt
  else
    tput setaf 3; echo "Concord Version Out Of Date!!" && sleep 2 && tput setaf 7; echo "Downloading Newest Version From GitHub" && sleep 1 | tee -a $LogFile
    cd / && cd "$UserLocation"/Concord_Temp
    curl -L -o Concord.sh "$URL"
    clear && tput setaf 2; echo "Successfully Downloaded The Newest Version Of Concord" && sleep 2 | tee -a $LogFile
    tput setaf 7; echo "Adding Some Finishing Touchs, Please Wait" && sleep 2
    cd / && rm -f "$ScriptLocation"/Concord.sh
    cd / && rsync -av "$UserLocation"/Concord_Temp/Concord.sh "$ScriptLocation"
    cd / && chmod +x "$ScriptLocation"/Concord.sh
    cd / && rm -rf "$UserLocation"/Concord_Temp
    cd / && rm -rf "$UserLocation"/Concord_Temp/ConcordVersionList.txt
    clear && tput setaf 3; echo "Please Re-run Script Using Concord.sh not Concord_macOS.sh" && sleep 2 && exit 0
fi

# The Start Of The Script For The User
cd /
tput setaf 7; clear && echo Running Concord v1.5 | tee "$LogFile"
sleep 2
echo '' | tee -a "$LogFile"
# Puts The Date/Time Of When The Script Was Started On The ScriptProgress Log
echo '' | tee -a "$LogFile"
echo "When Concord Was Started On By $SUDO_USER (UTC Formatted)" | tee -a "$LogFile"
date -u | tee -a "$LogFile"
# Adds The OS Version Of The Host To ScriptProgress Log
clear && echo '' | tee -a "$LogFile"
clear && echo "The OS Version The Host Is Running" | tee -a "$LogFile"
uname -a | tee -a "$LogFile"
clear && echo '' | tee -a "$LogFile"

# Asks If The User Wants To Use

# Allows The User To See What Drives They Can Backup
clear && tput setaf 7; echo "Scanning For Any Mounted Drives"
clear && sleep 1
tput setaf 6; echo  "Current Mounted Drive List On Local Machine"
echo "Ex: Macintosh HD Would Be A Valid Name"
echo '' && cd /
tput setaf 6; echo "What Drive Would You Like To Select?"
cd / && cd "$DriveFolder"
tput setaf 7; ls
echo '' && cd /
echo -n 'SourceDrive: '
read SourceDrive
cd /
clear && echo "You Have Selected "$SourceDrive"" | tee -a "$LogFile"
sleep 2 && clear

# Scans The Drive For A Certain Folder So The Backup Will Know If macOS Installed Or Windows Installed
cd /
if [ -d "$DriveFolder"/"$SourceDrive"/"Windows" ]; then
               clear && tput setaf 2; echo "Found Windows Installed!" | tee -a "$LogFile"
               sleep 1 && SourceDrivePath="$DriveFolder"/"$SourceDrive"/Users
               clear && tput setaf 7
            fi

if [ -d "$DriveFolder"/"$SourceDrive"/"Library" ]; then
                clear && tput setaf 2; echo "Found macOS Installed!" | tee -a "$LogFile"
                sleep 1 && SourceDrivePath="$DriveFolder"/"$SourceDrive"/Users
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
echo '' | tee -a "$LogFile"
echo "$SUDO_USER Selected "$Profile" For The Profile To Be Backed Up" | tee -a "$LogFile"
clear

# Makes Sure That The User Selected The Right Profile For The Source Backup Profile
tput setaf 6; echo "Now Verfying "$Profile" Exists" && sleep 2 && clear
cd /
tput setaf 1; [ ! -d "$SourceDrivePath"/"$Profile" ] && clear && echo "Could Not Find Profile, Please Try Again" && exit | tee -a "$LogFile"
tput setaf 7; clear && echo "Successfully Verified User Profile" | tee -a "$LogFile"
sleep 2 && clear

# Adds A Line For The Incoming Folder Size In ScriptProgress Logging
echo '' | tee -a "$LogFile"
echo "Here's The Estimated Folder Sizes For The Backup" | tee -a "$LogFile"
clear

# Scans The Profile Of A Estimated Size Of The Profile By Using du
tput setaf 6; echo "Scanning User Profile Now, Please Wait"
echo ''
cd / && tput setaf 7; du -skh "$SourceDrivePath"/"$Profile"/*/ | tee -a "$LogFile"
echo ''
tput setaf 2; echo "Finished Scanning Profile"
tput setaf 7; read -n 1 -s -r -p "Press any key to continue"
clear && tput setaf 6; echo "Please Select Your Destination Drive"
cd / && tput setaf 7;
PS3='Destination Drive Type: '
options=("Network SMB Share (fs3.liberty.edu\hdbackups)" "Local Mounted Drive")
select opt in "${options[@]}"
do
    case $opt in

# The Network SMB Share Portion Of The Destination Drive Script
# Works With General Linux (Ubnutu) And macOS
# macOS - This Uses A AppleScript Command To Mount The SMB Share For Sercurity And For Simple Usage
# Linux - Asks For User To Input Liberty Username And mount.cifs Will Ask For The Password For That Account (Saves Time With Variables)
# This Also Uses A Variable For The Mounted Drive Path For Simple Usage
        "Network SMB Share (fs3.liberty.edu\hdbackups)" )
        clear && echo "Starting fs3.liberty.hdbackups Mounting Process" && sleep 2
        clear && cd /

# Linux Version Of The SMB Mounting Process
# Uses mount.cifs To Mount fs3.liberty.edu\hdbackups To "hdbackups"
            if [ -d "media" ]; then
              echo '' | tee -a "$LogFile"
              echo "$SUDO_USER Selected Network SMB Share, Mounting fs3.liberty.edu\hdbackups" | tee -a "$LogFile"
              clear && echo "Please Enter Your Liberty Username"
              read User
              clear
              cd / && cd media && mkdir hdbackups
              tput setaf 6; echo "Now Mounting fs3.liberty.edu/hdbackups"
              tput setaf 7; cd / && clear && mount.cifs -v -o domain=SENSENET,username="$User",vers=2.0 //fs3.liberty.edu/hdbackups /media/hdbackups | tee -a "$LogFile"
              tput setaf 6; cd /media/hdbackups && clear && echo "Verfying fs3.liberty.edu Was Mounted Properly" && sleep 2
              cd  /media/hdbackups
                if [ -d "backups" ]; then
                  clear && cd /
                  tput setaf 2; echo "Successfully Mounted fs3.liberty.edu/hdbackups" && sleep 2 | tee -a "$LogFile"
                  Destination=/media/hdbackups/backups
                    fi
            fi

# macOS Version Of The SMB Mounting Process
# Uses A Applescript To Mount fs3.liberty.edu\hdbackups
            if [ -d "Volumes" ]; then
              echo '' | tee -a "$LogFile"
              echo "$SUDO_USER Selected Network SMB Share, Mounting fs3.liberty.edu\hdbackups" | tee -a "$LogFile"
              clear && tput setaf 6; echo "Now Mounting fs3.liberty.edu/hdbackups"
              sleep 1
                osascript -e 'mount volume "smb://fs3.liberty.edu/hdbackups"'
                end tell
              cd /volumes/hdbackups && clear && echo "Verfying fs3.liberty.edu/hdbackups Was Mounted Properly" && sleep 2
                if [ -d "backups" ]; then
                    clear && cd /
                    tput setaf 2; echo "Successfully Mounted fs3.liberty.edu/hdbackups" && sleep 2 | tee -a "$LogFile"
                    Destination=Volumes/hdbackups/backups
                      fi
                fi
            ;;

# Local Mounted Drive List
# Allows The User To Use A Mounted Drive To Backup To
# Updated Script To Work With Mounted Linux Drives
        "Local Mounted Drive")
            echo "you chose choice 2"
            ;;
        *) echo "invalid option $REPLY";;
    esac

# Makes The User Type In The CS Number For The Backup And Creates A Variable For The CS Number For Simple Usage
                  tput setaf 7; clear && echo "Please Enter The CS Number"
                  echo -n 'CS: '
                  read CS
                  echo "User Entered "$CS" For The CS Number" | tee -a "$LogFile"
                  echo '' | tee -a "$LogFile"
                  cd /

# Creates The Backup Folder With The CS Number On The Destination Path
                  cd / && mkdir "$Destination"/"$CS"
                  echo "Successfully Created A $CS Folder On ""$Destination" | tee -a "$LogFile"
                  cd / && mkdir "$Destination"/"$CS"/"$Profile"
                  echo "Successfully Created A "$Profile" Labeled Folder On "$Destination"/"$CS/"" | tee -a "$LogFile"
                  clear
                  echo '' | tee -a "$LogFile"

# Allows The Script To Access The User's Folder
                  clear && echo "Allowing Read And Write Access For The Folders That Need To Be Backup"
                  cd / && sleep 1
                  chmod -R 777 "$SourceDrivePath"/"$Profile"
                  echo "Successfully Chmod 777 "$Profile"'s Profile" | tee -a "$LogFile"
                  echo '' | tee -a "$LogFile"
                  clear && echo Now Backing Up "$SourceDrivePath"/"$Profile" "" To "$Destination"/"$CS"/"$Profile" | tee -a "$LogFile"
                  sleep 1 && cd /

# The Windows Backup Part Using Rsync To Backup Certain Folders On The Source Drive
                             if [ -d "$DriveFolder"/"$SourceDrive"/Windows  ]; then
                                           cd /
                                           clear && echo "Backing Up $Profile's Desktop"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Desktop "$Destination"/"$CS"/"$Profile"
                                           sleep 5
                                           clear && echo "Backing Up $Profile's Downloads"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Downloads "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Documents"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Documents "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Videos"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Videos "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Pictures"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Pictures "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Music"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Music "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profiles's Browser Bookmarks"
                                           cd / && cd "$Destination"/"$CS"/"$Profile" && mkdir Browser_Bookmarks && cd cd "$Destination"/"$CS"/"$Profile"/Browser_Bookmarks && mkdir Chrome && mkdir Firefox && mkdir "Internet Explorer"
                                           cd /
                                           rsync -azhp  "$SourceDrivePath"/"$Profile"/AppData/Roaming/Mozilla/Firefox/Profiles/*/places.sqlite "$Destination"/"$CS"/"$Profile"/Browser_Bookmarks/FireFox
                                           rsync -azhp  "$SourceDrivePath"/"$Profile"/AppData/Local/Google/Chrome/"User Data"/Default/Bookmarks "$Destination"/"$CS"/"$Profile"/Browser_Bookmarks/Chrome
                                           rsync -azhp  "$SourceDrivePath"/"$Profile"/Favorites "$Destination"/"$CS"/"$Profile"/Browser_Bookmarks/"Internet Explorer"
                                           clear && echo "Backing Up $Profile's Sticky Notes"
                                           rsync -azhp  "$SourceDrivePath"/"$Profile"/AppData/Roaming/Microsoft/Signatures/ "$Destination"/"$CS"/"$Profile"
                                           clear && tput setaf 2; echo "Successfully Copied "$Profile" To "$Destination"" | tee -a "$LogFile"
                                           sleep 3 && clear
                                           tput setaf 6; echo "Now Verfying Backup Size And Counting Files That Were Backed Up" && sleep 2
                                           clear && echo '' | tee -a "$LogFile"
# Where The Data Backup Is Verified Via A File Count And Backup Size Count
                                           tput setaf 7; echo "The Final Backup Data Size On "$Destination"/"$CS"/"$Profile" Is" | tee -a "$LogFile"
                                           cd / && du -hd1 "$Destination"/"$CS"/ | tee -a "$LogFile"
                                           cd / && echo '' | tee -a "$LogFile"
                                           echo "The Final Destination And Source File Count Is" | tee -a "$LogFile"
                                           cd / && echo "Destination File Count" | tee -a "$LogFile"
                                           cd / && cd "$Destination"/"$CS"/"$Profile"
                                           DestinationFiles=`ls Desktop Documents Downloads Videos Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                                           cd / && echo "$DestinationFiles" | tee -a "$LogFile"
                                           cd / && echo "Source File Count" | tee -a "$LogFile"
                                           cd / && cd "$SourceDrivePath"/"$Profile"
                                           SourceFiles=`ls Desktop Documents Downloads Videos Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                                           cd / && echo "$SourceFiles" | tee -a "$LogFile"
                                           echo ''
                                           read -n 1 -s -r -p "Press any key to continue"
                                           clear
                                           echo "Copying Script Log To "$Destination"/"$CS"/"$Profile""
                                           cd / && rsync -azhp  Users/"$SUDO_USER"/Desktop/-a "$LogFile" "$Destination"/"$CS"
                                           clear && echo "Thank You For Running Concord v1.5"
                                           sleep 3 && exit 0
                                         fi

# The macOS Backup Part Using Rsync To Backup Certain Folders On The Source Drive
                               if [ -d "$DriveFolder"/"$SourceDrive"/Library ]; then
                                           cd /
                                           clear && echo "Backing Up $Profile's Desktop"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Desktop "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Downloads"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Downloads "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Documents"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Documents "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Movies"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Movies "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Pictures"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Pictures "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profile's Music"
                                           rsync -azhp  --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$SourceDrivePath"/"$Profile"/Music "$Destination"/"$CS"/"$Profile"
                                           clear && echo "Backing Up $Profiles's Browser Bookmarks"
                                           cd / && cd "$Destination"/"$CS"/"$Profile" && mkdir Browser_Bookmarks
                                           cd Browser_Bookmarks && mkdir Chrome && mkdir Firefox && mkdir Safari
                                           cd /
                                           rsync -azhp  "$SourceDrivePath"/"$Profile"/Library/"Application Support"/Google/Chrome/Default "$Destination"/"$CS"/"$Profile"/Browser_Bookmarks/Chrome
                                           rsync -azhp "$SourceDrivePath"/"$Profile"/Library/"Application Support"/Firefox/Profiles "$Destination"/"$CS"/"$Profile"/Browser_Bookmarks/FireFox
                                           rsync -azhp "$SourceDrivePath"/"$Profile"/Library/Safari/Bookmarks.plist "$Destination"/"$CS"/"$Profile"/Browser_Bookmarks/Safari
                                           clear && tput setaf 2; echo "Successfully Copied "$Profile" To ""$Destination" | tee -a "$LogFile"
                                           sleep 3 && clear
                                           tput setaf 6; echo "Now Verfying Backup Size And Counting Files That Were Backed Up" && sleep 2
                                           clear && echo '' | tee -a "$LogFile"
# Where The Data Backup Is Verified Via A File Count And Backup Size Count
                                           tput setaf 7; echo "The Final Backup Data Size On "$Destination"/"$CS"/"$Profile" Is" | tee -a "$LogFile"
                                           cd / && du -hd1 "$Destination"/"$CS"/ | tee -a "$LogFile"
                                           cd / && echo '' | tee -a "$LogFile"
                                           echo "The Final Destination And Source File Count Is" | tee -a "$LogFile"
                                           cd / && echo "Destination File Count" | tee -a "$LogFile"
                                           cd / && cd "$Destination"/"$CS"/"$Profile"
                                           DestinationFiles=`ls Desktop Documents Downloads Movies Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                                           cd / && echo "$DestinationFiles" | tee -a "$LogFile"
                                           cd / && echo "Source File Count" | tee -a "$LogFile"
                                           cd / && cd "$SourceDrivePath"/"$Profile"
                                           SourceFiles=`ls Desktop Documents Downloads Movies Pictures Music | grep -v ".exe" | grep -v ".ini" | wc -l | awk '{$1=$1};1'`
                                           cd / && echo "$SourceFiles" | tee -a "$LogFile"
                                           echo ''
                                           read -n 1 -s -r -p "Press any key to continue"
                                           clear
                                           echo "Copying -a "$LogFile" To "$Destination"/"$CS"/"$Profile""
                                           cd / && rsync -azhp  Users/"$SUDO_USER"/Desktop/-a "$LogFile" "$Destination"/"$CS"
                                           clear && echo "Thank You For Running Concord v1.5"
                                           sleep 3 && exit 0
                                         fi
done
