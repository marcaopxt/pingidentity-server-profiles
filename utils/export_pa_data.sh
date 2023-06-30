#!/bin/bash

TRIES=10
PA_ADMIN_URL='https://pingaccess-admin.local:8443'


_export_id=$(curl -s -k --location -X POST ${PA_ADMIN_URL}/pa-admin-api/v3/config/export/workflows \
--header 'X-XSRF-Header: PingAccess' \
--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' | jq -r .id); 

#_export_id=`echo $_export_request | jq -r .id`

#echo -e "export_id $_export_id"; 

for (( i = 0; i < $TRIES; i++ )); do 

	_export_status=$(curl -s -k --location ${PA_ADMIN_URL}/pa-admin-api/v3/config/export/workflows/${_export_id} \
		--header 'X-XSRF-Header: PingAccess' \
		--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' | jq -r .status); 

#	echo -e "status($_export_id) - $_export_status"; 

	if [ "$_export_status" == "Complete" ]; then 
		break;
	else
		sleep 1;
	fi

	if [ $i == 9 ]; then 
		echo -e "FAIL TO EXPORT";
		exit 1;
	fi

done

curl -s -k --location -X GET ${PA_ADMIN_URL}/pa-admin-api/v3/config/export/workflows/${_export_id}/data \
		--header 'X-XSRF-Header: PingAccess' \
		--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl';


