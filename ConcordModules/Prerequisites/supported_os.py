###########################
# Concord V2 Supported OS #
###########################

import platform

# Looks For Installed OS (Windows, macOS, Linux)
def os_type_detection():
    platform.system() + " " + platform.release() + " " + platform.version()

    return LocalHostOS_System

# (Temp) Supported Platforms
if LocalHostOSType == "macOS":
    print("Local Host OS: " + LocalHostOSType + " Is Supported")
else:
    print("Local Host OS: " + LocalHostOSType + " Is Not Supported, Exiting Script...")