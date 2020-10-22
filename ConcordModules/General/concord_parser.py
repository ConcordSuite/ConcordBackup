##############################
# Concord JSON Parser Module #
##############################

import json
import os

# Gets Current Working Directory Of Script
def GeneralJSONParseLocation():
    GeneralJSONParseFullPath = os.getcwd()
    return GeneralJSONParseFullPath

# Parses JSON Content For Concord To Use In Python Scripts....  I don't know what else to add here lol
# inputCategory, inputValue
def GeneralJSONToDict(inputFile):
    JSONParseLocation = GeneralJSONParseLocation()
    with open(JSONParseLocation + inputFile) as json_file:
        rawJSONdata = json.load(json_file)
        return rawJSONdata
