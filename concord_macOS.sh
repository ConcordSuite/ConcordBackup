#!/bin/bash
if [ "$EUID" -ne 0 ]
then echo "Can Not Run Script With Non Sudo Rights!" && echo "Try Running sudo ./concord.sh "
exit
fi
clear && echo Running Concord v1 Beta
sleep 1
clear && tput setaf 3; echo This Script Only Runs On macOS And Not General Linux Distros Like Ubuntu Yet
read -n 1 -s -r -p "Press any key to continue"
clear && tput setaf 7; echo Scanning For Any Mounted Drivess
clear && sleep 1
tput setaf 6; echo  "Current Mounted Drive List"
echo "Please Type In The Correct Drive Name You Want To Use As The Source Drive"
echo "Ex: Macintosh HD Would Be A Valid Name"
echo ''
tput setaf 7; diskutil list
echo -n 'SourceDrive: '
read SourceDrive
clear && echo "You Have Selected $SourceDrive"
clear && sleep 2
cd /
if [ -d "Volumes/"$SourceDrive"/Windows" ]; then
               clear && tput setaf 2; echo "Found Windows Installed!"
               sleep 1 && SourceDrivePath=Volumes/"$SourceDrive"/Users
               clear && tput setaf 7
            fi
if [ -d "Volumes/$SourceDrive/Library" ]; then
                clear && tput setaf 2; echo "Found macOS Installed!"
                sleep 1 && SourceDrivePath=Volumes/"$SourceDrive"/Users
                clear && tput setaf 7
              fi
tput setaf 6; echo "What User Profile Do You Want To Backup?"
cd / && cd "$SourceDrivePath"
tput setaf 7; ls
echo -n 'Profile: '
read Profile
clear && echo "Estimating Profile Size Now"
sleep 1
cd / && cd "$SourceDrivePath/$Profile"
clear && Source=$SourceDrivePath/$Profile
tput setaf 6; echo "Scanning Profile Now, Please Wait"
echo ''
tput setaf 7; du -skh ./*/
echo ''
tput setaf 2; echo "Finished Scanning Profile"
tput setaf 7; read -n 1 -s -r -p "Press any key to continue"
clear && tput setaf 6; echo "Please Select Your Destination Drive Part 1"
cd / && tput setaf 7;
PS3='Destination Drive Type '
options=("Network SMB Share (fs3.liberty.edu\hdbackups)" "Local Mounted Drive" )
select opt in "${options[@]}"
do
    case $opt in
        "Network SMB Share (fs3.liberty.edu\hdbackups)")
                  clear && tput setaf 6; echo "Mounting fs3.liberty.edu\hdbackups Part 2"
                  osascript -e 'mount volume "smb://fs3.liberty.edu/hdbackups"'
                  end tell
                  clear && Destination=volumes/hdbackups/backups
                  cd / && cd $Destination
                  tput setaf 2; echo "Succesfully Mounted HDbackups"
                  tput setaf 7 && sleep 2
            ;;
        "Local Mounted Drive")
        clear && tput setaf 7; echo Scanning For Any Mounted Drivess
          sleep 1
              clear && tput setaf 6; echo  "Current Mounted Drive List"
              echo "Please Type In The Correct Drive Name You Want To Use As The Destination Drive"
              echo "Ex: Macintosh HD Would Be A Valid Name"
              echo ''
              tput setaf 7; diskutil list
              echo -n 'DestinationDrive: '
              read DestinationDrive
              clear && Destination=volumes/"$DestinationDrive"
              echo You Have Selected "$DestinationDrive" && sleep 1
              cd / && cd "$Destination"
            ;;
            *) tput setaf 1; clear && echo "Invalid Option, Exiting Script lol"
                echo ''
                tput setaf 7; echo "You Selected ($REPLY)"
                echo "You Had One Job Buddy But You Failed, Select One From The List Next Time"
                break;;
    esac
          clear && echo "Please Enter The CS Number"
          echo -n 'CS: '
            read CS
            cd /
              mkdir "$Destination"/"$CS"
              mkdir "$Destination"/"$CS"/"$Profile"
          clear && echo "Allowing Read And Write Access For The Folders That Need To Be Backup"
          cd / && sleep 1
          chmod 755 "$Source"
          echo Now Backing Up "$Source"
          sleep 1
          if [ -d Volumes/"$SourceDrive"/Windows ]; then
                        clear && echo "Backing Up $Profile's Desktop"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Desktop "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Downloads"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Downloads "$DestinationD"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Documents"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Documents "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Videos"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Videos "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Pictures"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Pictures "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Music"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Music "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profiles's Browser Bookmarks"
                        rsync -azhp "$Source"/AppData/Roaming/Mozilla/Firefox/Profiles/*/places.sqlite "$Destination"/"$CS"/"$Profile"
                        rsync -azhp "$Source"/AppData/Local/Google/Chrome/"User Data"/Default/Bookmarks "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Sticky Notes"
                        rsync -azhp "$Source"/AppData/Roaming/Microsoft/Signatures/ "$Destination"/"$CS"/"$Profile"
                        clear && tput setaf 2; echo "Succesfully Copied $Profile To $Destination"
                        clear && tput setaf 7; echo "Data Logging Feature Will Be Added Soon"
                        read -n 1 -s -r -p "Press any key to continue"
                        clear && exit
                      fi
            if [ -d Volumes/"$SourceDrive"/Library ]; then
                        clear && echo "Backing Up $Profile's Desktop"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Desktop "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Downloads"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Downloads "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Documents"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Documents "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Movies"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Movies "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Pictures"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Pictures "$Destination"/"$CS"/"$Profile"
                        clear && echo "Backing Up $Profile's Music"
                        rsync -azhp --exclude '*.exe' --exclude '*.zip' --exclude '*.ini' "$Source"/Music "$Destination"/"$CS"/"$Profile"
                        clear && tput setaf 7; echo "Data Logging Feature Will Be Added Soon"
                        read -n 1 -s -r -p "Press any key to continue"
                        clear && exit
                      fi
done
