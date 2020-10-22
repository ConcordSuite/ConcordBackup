###################################
# Concord macOS Data Index Module #
###################################

# Indexes Connected Drives On Local macOS Device As A Module
# Collects Path For Volume, Drive Type (System/OS Or NonBootable), Used/Free/Total Drive Space, User Folder/Folder Data Sizes

# Test
def Test(name):
    print("Concord V2 Test")
    print("Hello," +  " " + name + "!")

def ConnectedDriveFinder():
    ConnectedDrivesList = os.listdir(macOSPrimaryConnectedDriveLocation)
    ConnectedDrivesListPaths = [macOSPrimaryConnectedDriveLocation + x for x in ConnectedDrivesList]