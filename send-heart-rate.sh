#!/bin/bash

minHeartRate=30
maxHeartRate=170
sendTimeoutSeconds=5
serverEndpoint="http://localhost:8080/graphql"
jwtToken=""
heartRate=0

if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
	echo "This script generate heart rate and send it to server with a timeout."
	echo "This is useful for developing application."
	echo "You may use this script to simulate user's heart beat."
	echo
	echo "OPTIONS:"
	echo "  -l	minimal user's heat rate (30 by default)"
	echo "  -h	highest user's heat rate (170 by default)"
	echo "  -t	timeout between sending heart rates (5 by default)"
	echo "  -e	server GraphQL endpoint ('http://localhost:8080/graphql' by default)"
	echo "  -j	JWT token to use. Required!"
	exit
fi

ValidateNumberParameter() {
	re='^[0-9]+$'
	if ! [[ $2 =~ $re ]] ; then
	   echo "error: Parameter '$1' must be a number."
	   exit
	fi
}

while getopts :l:h:t:e:j: flag ; do
	case "${flag}" in
        l)
		   	ValidateNumberParameter '-l' "${OPTARG}"
		   	minHeartRate=${OPTARG};;
        h) 
		   	ValidateNumberParameter '-h' "${OPTARG}"
		   	maxHeartRate=${OPTARG};;
		t)
		   	ValidateNumberParameter '-t' "${OPTARG}"
			sendTimeoutSeconds=${OPTARG};;
		e)
			serverEndpoint=${OPTARG};;
		j)
			jwtToken=${OPTARG};;
		\?)
           	echo "Error: Invalid option '${OPTARG}'"
           	exit;;
    esac
done

if [ "$jwtToken" = "" ] ; then
	echo "You must specify JWT token!"
	echo "Please, provide -j parameter."
	echo "Use -h or --help parameter to display availiable parameters."
	exit
fi

GenerateHeartRate() {
	heartRate=$(( $RANDOM % $maxHeartRate + $minHeartRate ))

	if [ $heartRate -gt $maxHeartRate ] ; then
		heartRate=$maxHeartRate
	fi

	if [ $heartRate -lt $minHeartRate ] ; then
		heartRate=$minHeartRate
	fi
}

while true ; do
	GenerateHeartRate
	echo "Sending heart rate: $heartRate"

	query='{"query":"mutation($heartRate:Float!){sendHeartRate(data:{heartRate:$heartRate})}","variables":{"heartRate":'
	query+=$heartRate
	query+='}}'

	curl --silent \
		-X POST \
		-H "Content-Type: application/graphql+json" \
		-H "Authorization: Bearer $jwtToken" \
		-d $query \
		$serverEndpoint > /dev/null
	
	sleep $sendTimeoutSeconds
done