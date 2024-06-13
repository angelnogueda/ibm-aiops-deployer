#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#         ________  __  ___     ___    ________       
#        /  _/ __ )/  |/  /    /   |  /  _/ __ \____  _____
#        / // __  / /|_/ /    / /| |  / // / / / __ \/ ___/
#      _/ // /_/ / /  / /    / ___ |_/ // /_/ / /_/ (__  ) 
#     /___/_____/_/  /_/    /_/  |_/___/\____/ .___/____/  
#                                           /_/
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------"
#  IBMAIOPS - Generate Log Files for Injection
#
#
#  ©2024 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


export num_log_lines=10000
export time_increment_sec=10
export WORKING_DIR_LOGS=/tmp/testlogs


clear

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 IBM AIOps - Generate Log Files for Injection"
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "


echo " "
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "   🚀  Initializing..."
echo "   ------------------------------------------------------------------------------------------------------------------------------"







mkdir $WORKING_DIR_LOGS  >/tmp/demo.log 2>&1  || true

echo "">$WORKING_DIR_LOGS/test1.json
echo "">$WORKING_DIR_LOGS/test2.json
echo "">$WORKING_DIR_LOGS/test3.json


export utc_timestamp=$(date +'%Y-%m-%d %H:%M:%S.000')
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "    🚀 Logs Starting at $utc_timestamp"
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo " "


for i in $(seq 1 10 $(($num_log_lines*$time_increment_sec)))
do

export my_timestamp=$(date -v+${i}S +'%s')
export utc_timestamp=$(date -v+${i}S +'%Y-%m-%d %H:%M:%S.000')



printf "       $(($i/$time_increment_sec))/$num_log_lines"\\r
echo "{\"timestamp\": $my_timestamp"000",\"utc_timestamp\": \"$utc_timestamp\", \"features\": [], \"meta_features\": [],\"instance_id\": \"acme-booking-service\",\"application_group_id\": \"1000\",\"application_id\": \"1000\",\"level\": 1,\"message\": \"[$my_timestamp] All is good in acme-booking-service. \",\"entities\": {\"pod\": \"acme-booking-service\",\"cluster\": null,\"container\": \"acme-booking-service\",\"node\": \"kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34\"},\"type\": \"StandardLog\"},">>$WORKING_DIR_LOGS/test1.json
echo "{\"timestamp\": $my_timestamp"000",\"utc_timestamp\": \"$utc_timestamp\", \"features\": [], \"meta_features\": [],\"instance_id\": \"acme-booking-db\",\"application_group_id\": \"1000\",\"application_id\": \"1000\",\"level\": 1,\"message\": \"[$my_timestamp] All is good in acme-booking-db. \",\"entities\": {\"pod\": \"acme-booking-db\",\"cluster\": null,\"container\": \"acme-booking-db\",\"node\": \"kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34\"},\"type\": \"StandardLog\"},">>$WORKING_DIR_LOGS/test2.json
echo "{\"timestamp\": $my_timestamp"000",\"utc_timestamp\": \"$utc_timestamp\", \"features\": [], \"meta_features\": [],\"instance_id\": \"acme-web\",\"application_group_id\": \"1000\",\"application_id\": \"1000\",\"level\": 1,\"message\": \"[$my_timestamp] All is good in acme-web. \",\"entities\": {\"pod\": \"acme-web\",\"cluster\": null,\"container\": \"acme-web\",\"node\": \"kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34\"},\"type\": \"StandardLog\"},">>$WORKING_DIR_LOGS/test3.json

echo "{\"timestamp\": $my_timestamp"000",\"utc_timestamp\": \"$utc_timestamp\", \"features\": [], \"meta_features\": [],\"instance_id\": \"dSwitch-5-vm-network-port-1\",\"application_group_id\": \"1000\",\"application_id\": \"1000\",\"level\": 1,\"message\": \"[$my_timestamp] dSwitch 5 - vm-network - port-1 is up.\",\"entities\": {\"pod\": \"dSwitch-5-vm-network-port-1\",\"cluster\": null,\"container\": \"dSwitch-5-vm-network-port-1\",\"node\": \"dcwest1-switch025\"},\"type\": \"StandardLog\"},">>$WORKING_DIR_LOGS/test4.json
echo "{\"timestamp\": $my_timestamp"000",\"utc_timestamp\": \"$utc_timestamp\", \"features\": [], \"meta_features\": [],\"instance_id\": \"catalogue-db\",\"application_group_id\": \"1000\",\"application_id\": \"1000\",\"level\": 1,\"message\": \"[$my_timestamp] All is good in catalogue-db. \",\"entities\": {\"pod\": \"catalogue-db\",\"cluster\": null,\"container\": \"catalogue-db\",\"node\": \"kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34\"},\"type\": \"StandardLog\"},">>$WORKING_DIR_LOGS/test5.json
echo "{\"timestamp\": $my_timestamp"000",\"utc_timestamp\": \"$utc_timestamp\", \"features\": [], \"meta_features\": [],\"instance_id\": \"catalogue-network\",\"application_group_id\": \"1000\",\"application_id\": \"1000\",\"level\": 1,\"message\": \"[$my_timestamp] All is good in catalogue-network. \",\"entities\": {\"pod\": \"catalogue-network\",\"cluster\": null,\"container\": \"catalogue-network\",\"node\": \"kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34\"},\"type\": \"StandardLog\"},">>$WORKING_DIR_LOGS/test6.json
done

printf "       Done       "\\r

export utc_timestamp=$(date -v+${i}S +'%Y-%m-%d %H:%M:%S.000')
echo " "
echo " "
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "    ✅ Logs Ending at $utc_timestamp"
echo "   ------------------------------------------------------------------------------------------------------------------------------"



#ls -al $WORKING_DIR_LOGS


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  ✅ Done"
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"


exit 1



{"timestamp": 1581549409000,"instance_id": "calico-node-jn2d2","application_group_id": "1000","application_id": "1000","level": 1,"message": "[64] ipsets.go 254: Resyncing ipsets with dataplane. family=\"inet\"","entities": {"pod": "calico-node-jn2d2","cluster": null,"container": "calico-node","node": "kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34"},"type": "StandardLog"}


{
    "timestamp": 1581549409000,
    "utc_timestamp": "2020-02-12 23:16:49.000",
    "instance_id": "calico-node-jn2d2",
    "application_group_id": "1000",
    "application_id": "1000",
    "features": [], "meta_features": [],
    "level": 1,
    "message": "[64] ipsets.go 254: Resyncing ipsets with dataplane. family=\"inet\"",
    "entities": {
        "pod": "calico-node-jn2d2",
        "cluster": null,
        "container": "calico-node",
        "node": "kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34"
    },
    "type": "StandardLog"
}

{
	"_index": "1000-1000-20230830-logtrain",
	"_type": "_doc",
	"_id": "1723471282",
	"_version": 1,
	"_seq_no": 1,
	"_primary_term": 1,
	"found": true,
	"_source": {
		"timestamp": 1693404950000,
		"instance_id": "test1",
		"application_group_id": "1000",
		"application_id": "1000",
		"level": 1,
		"message": "[64] ipsets.go 254: Resyncing ipsets 1 with dataplane. ",
		"entities": {
			"pod": "test 1",
			"cluster": null,
			"container": "test",
			"node": "kube-bmgcm5td0stjujtqv8m0-ai4itsimula-wp16cpu-00002c34"
		},
		"type": "StandardLog",
		"oob_entities": {
			"message_id": null,
			"log_level": null
		},
		"named_entities": {
			"error_code": [],
			"exception": [],
			"error_log": [],
			"normal": [
				"normal"
			]
		},
		"elastic_index_id": 1723471282,
		"meta_features": [
			{
				"type": "WindowMeta",
				"obj_value": {
					"start": 1693404950000,
					"end": 1693404960000
				}
			}
		]
	}
}