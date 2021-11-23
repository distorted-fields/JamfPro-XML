#!/bin/bash
#
#
#
#           Created by A.Hodgson                     
#            Date: 2021-11-22                            
#            Purpose: Upload XML data to appropriate API endpoint 
#
#
#
#############################################################
function apiResponse() #takes api response code variable
{
  if [ "$1" == "201" ] ; then
    echo "Success - $1"
  else
    echo "Failed - $1"
  fi
}
#############################################################
# 
#############################################################
read -r -p "Please enter a JAMF instance to take action on: " jamfProURL
read -r -p "Please enter a JAMF API administrator name: " apiUser
read -r -s -p "Please enter the password for the account: " apiPass
echo ""
#prompt user and loop until we have a valid option 
while true; do
	echo ""
	echo "What is your target?"
	echo "1 - Policy"
	echo "2 - Profile"
	read -p "Please enter an option number: " option

	case $option in 
		1)
			endpoint="policies"
			break
			;;
		2)
			endpoint="osxconfigurationprofiles"
			break
			;;
		*)
			echo "That is not a valid choice, try a number from the list."
     		;;
    esac
done


read -p "Drag and drop your profile XML data file: " xml_data
# convert file into variable
xml=$(cat $xml_data)


api_response=$(curl --write-out "%{http_code}" -sku ${apiUser}:${apiPass} -H "Content-Type: text/xml" ${jamfProURL}/JSSResource/${endpoint}/id/0 -d "${xml}" -X POST)
responseStatus=${api_response: -3}
apiResponse "$responseStatus"