
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# SIMULATE INCIDENT ON ROBOTSHOP
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export NETCOOL_WEBHOOK_GENERIC=not_configured

export APP_NAME=robot-shop
export LOG_TYPE=elk   # humio, elk, splunk, ...
export EVENTS_TYPE=noi


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
clear

echo ""
echo ""
echo ""
echo ""
echo ""
echo "         ________  __  ___     ___    ________       "     
echo "        /  _/ __ )/  |/  /    /   |  /  _/ __ \____  _____"
echo "        / // __  / /|_/ /    / /| |  / // / / / __ \/ ___/"
echo "      _/ // /_/ / /  / /    / ___ |_/ // /_/ / /_/ (__  ) "
echo "     /___/_____/_/  /_/    /_/  |_/___/\____/ .___/____/  "
echo "                                           /_/            "
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  IBMAIOPS Simulate Outage for $APP_NAME"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"


# Get Namespace from Cluster 
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "   🔬 Getting Installation Namespace"
echo "   ------------------------------------------------------------------------------------------------------------------------------"

export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
export EVTMGR_NAMESPACE=$(oc get po -A|grep noi-operator |awk '{print$1}')
echo "       ✅ OK - IBMAIOps:    $AIOPS_NAMESPACE"
echo "       ✅ OK - Event Manager: $EVTMGR_NAMESPACE"



# Define Log format
export log_output_path=/dev/null 2>&1
export TYPE_PRINT="📝 "$(echo $TYPE | tr 'a-z' 'A-Z')







#--------------------------------------------------------------------------------------------------------------------------------------------
#  Get Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "  🔐  Getting credentials"
echo "***************************************************************************************************************************************************"
oc project $EVTMGR_NAMESPACE >/dev/null 2>&1  || true
export WORKING_DIR_EVENTS="./tools/01_demo/INCIDENT_FILES/$APP_NAME/events-noi"
export EVTMGR_PASSWORD=$(oc get secrets | grep omni-secret | awk '{print $1;}' | xargs oc get secret -o jsonpath --template '{.data.OMNIBUS_ROOT_PASSWORD}' | base64 --decode)


#--------------------------------------------------------------------------------------------------------------------------------------------
#  Check Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "  🔗  Checking credentials"
echo "***************************************************************************************************************************************************"

if [[ $NETCOOL_WEBHOOK_GENERIC == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GENERIC == "" ]];
then
      echo "❌ Event Manager Webhook not configured. Aborting..."
      exit 1
else
      echo "      ✅ OK - Event Manager Webhook"
fi

if [[ $EVTMGR_PASSWORD == "" ]] ;
then
      echo "❌ Cannot contact Event Manager"
      echo "❌ Make sure that Event Manager is running. Aborting..."
      exit 1
else
      echo "      ✅ OK - Event Manager Password"
fi
echo ""
echo ""
echo ""
echo ""


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🔎  Parameter for Incident Simulation for $APP_NAME"
echo "  "
echo "  "
echo "           🔐 Event Manager WebHook       : $NETCOOL_WEBHOOK_GENERIC"
echo "           🔐 Event Manager Password      : $EVTMGR_PASSWORD"
echo "  "
echo "           📂 Directory for Events        : $WORKING_DIR_EVENTS"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "  🗄️  Files to be loaded for Events"
echo "***************************************************************************************************************************************************"
ls -1 $WORKING_DIR_EVENTS | grep "json"
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

echo ""
echo ""


#--------------------------------------------------------------------------------------------------------------------------------------------
#  Deleting Event Manager Events
#--------------------------------------------------------------------------------------------------------------------------------------------

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo " ❎  Deleting Event Manager Events for $APP_NAME" 
echo "--------------------------------------------------------------------------------------------------------------------------------"
oc get pods | grep ncoprimary-0 | awk '{print $1;}' | xargs -I{} oc exec {} -- bash -c "/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P -user root -passwd ${EVTMGR_PASSWORD} << EOF
delete from alerts.status where AlertGroup='$APP_NAME';
go
exit
EOF"

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Start creating Events
#--------------------------------------------------------------------------------------------------------------------------------------------

for actFile in $(ls -1 $WORKING_DIR_EVENTS | grep "json"); 
do 


    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo " 🌏  Injecting Events from File: ${actFile}" 
    echo "--------------------------------------------------------------------------------------------------------------------------------"

  
    while IFS= read -r line
    do
      export my_timestamp=$(date +%s)000

      echo "Injecting Event at: $my_timestamp"
      line=${line/MY_TIMESTAMP/$my_timestamp}

      curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GENERIC" \
        -H 'Content-Type: application/json; charset=utf-8' \
        -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
        -d $"${line}"
      echo "      ✅ OK"
    done < "$WORKING_DIR_EVENTS/$actFile"


done


