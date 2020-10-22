##################################
# Concord V2 Load Settings Script#
##################################
from ConcordModules.General.concord_parser import GeneralJSONToDict
import os

# Loads JSON Files To Python Dict
def load_general_settings():
    GeneralFile = "/ConcordModules/General/Settings.json"
    GeneralJSON = GeneralJSONToDict(GeneralFile)
    return GeneralJSON
def load_backup_settings():
    BackupFile = "/ConcordModules/General/Settings/Backup_Settings.json"
    BackupJSON = GeneralJSONToDict(BackupFile)
    return BackupJSON
def load_gui_settings():
    GUIFile = "/ConcordModules/General/Settings/GUI_Settings.json"
    GUIJSON = GeneralJSONToDict(GUIFile)
    return GUIJSON
def load_version_settings():
    VersionFile = "/ConcordModules/General/Settings/Version_Settings.json"
    VersionJSON = GeneralJSONToDict(VersionFile)
    return VersionJSON
def load_all_settings():
    GeneralSettings = load_general_settings()
    BackupSettings = load_backup_settings()
    GUISettings = load_gui_settings()
    VersionSettings = load_version_settings()
    return GeneralSettings,BackupSettings,GUISettings,VersionSettings

# Loads Python Dict Key/Values To Variables
#def create_concord_vara(GeneralSettings,BackupSettings,GUISettings,VersionSettings):
    #Concord_CombineDict = [GeneralSettings,BackupSettings,GUISettings,VersionSettings]
    #locals().update(GeneralSettings)



