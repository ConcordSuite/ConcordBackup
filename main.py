#############################
# Concord V2 Testing Script #
#############################
import sys
import os
from ConcordModules.Data_Index.macOS_data_index import Test
from ConcordModules.General.load_settings import load_all_settings

# Gets Preferences JSON Loaded And Looks For Custom Preference File
if __name__ == '__main__':
    GeneralSettings,BackupSettings,GUISettings,VersionSettings = load_all_settings()
    print(GeneralSettings["concord_backup_macOS_log_location"])

