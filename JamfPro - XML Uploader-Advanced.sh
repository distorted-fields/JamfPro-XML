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

#############################################################
# Configuration Arrays - format the array in terms of "api end point, github raw xml url"
#############################################################
malwarebytes_array=(
		"osxconfigurationprofiles,https://raw.githubusercontent.com/distorted-fields/xmltests/main/JamfPro-XML/KernExtProfile-Malwarebytes.xml"
		"osxconfigurationprofiles,https://raw.githubusercontent.com/distorted-fields/xmltests/main/JamfPro-XML/SystExtProfile-MalwareBytes.xml"
)
#############################################################
# Functions
#############################################################
function apiResponse() #takes api response code variable
{
  if [ "$1" == "201" ] ; then
    echo "Success - $1"
  else
    echo "Failed - $1"
  fi
}

function callAPI() #takes an array element as paameter
{
	 configuration_array=("$@")

	# Loop to run all configurations
  for install_item in "${configuration_array[@]}"; do
    endpoint=$(echo "$install_item" | cut -d ',' -f1)
    url=$(echo "$install_item" | cut -d ',' -f2)
		xml=$(curl -sk $url)
		api_response=$(curl --write-out "%{http_code}" -sku ${apiUser}:${apiPass} -H "Content-Type: text/xml" ${jamfProURL}/JSSResource/${endpoint}/id/0 -d "${xml}" -X POST)
		responseStatus=${api_response: -3}
		apiResponse "$responseStatus"
	done			
}
#############################################################
# MAIN
#############################################################
read -r -p "Please enter a JAMF instance to take action on: " jamfProURL
read -r -p "Please enter a JAMF API administrator name: " apiUser
read -r -s -p "Please enter the password for the account: " apiPass
echo ""
#prompt user and loop until we have a valid option 
while true; do
	echo ""
	echo "Select software to deploy default configurations?"
	echo "1 - Malwarebytes"
	read -p "Please enter an option number: " option

	case $option in 
		1) # Malwarebytes
			callAPI "${malwarebytes_array[@]}"
			break
			;;
		*)
			echo "That is not a valid choice, try a number from the list."
     		;;
    esac
done