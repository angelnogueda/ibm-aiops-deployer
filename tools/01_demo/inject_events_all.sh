
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# SIMULATE INCIDENT ON ROBOTSHOP
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



#declare -a ALL_APPS=("robot-shop" "sock-shop" "acme" "london-underground")
declare -a ALL_APPS=("robot-shop")



export APP_NAME=robot-shop
export EVENTS_SKEW="-1d"

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
echo " 🚀  IBMAIOPS Inject All Events for Temporal Training"
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      echo "       ✅ OK - MacOS"
else
      echo "❗ This tool currently only runs on Mac OS due to shell limitations."
      echo "❗ Please use the Demo Web UI for Incident simulation."
      echo "❌ Exiting....."
      exit 1 
fi

# Get Namespace from Cluster 
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "    🔬 Getting Installation Namespace"
echo "   ------------------------------------------------------------------------------------------------------------------------------"

export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
echo "       ✅ OK - IBMAIOps:    $AIOPS_NAMESPACE"



# Define Log format
export log_output_path=/dev/null 2>&1
export TYPE_PRINT="📝 "$(echo $TYPE | tr 'a-z' 'A-Z')


#------------------------------------------------------------------------------------------------------------------------------------
#  Check Defaults
#------------------------------------------------------------------------------------------------------------------------------------

if [[ $APP_NAME == "" ]] ;
then
      echo " ⚠️ AppName not defined. Launching this script directly?"
      echo "    Falling back to $DEFAULT_APP_NAME"
      export APP_NAME=$DEFAULT_APP_NAME
fi


oc project $AIOPS_NAMESPACE  >/tmp/demo.log 2>&1  || true

export USER_PASS="$(oc get secret aiops-ir-core-ncodl-api-secret -o jsonpath='{.data.username}' | base64 --decode):$(oc get secret -n $AIOPS_NAMESPACE aiops-ir-core-ncodl-api-secret -o jsonpath='{.data.password}' | base64 --decode)"
oc apply -n $AIOPS_NAMESPACE -f ./tools/01_demo/scripts/datalayer-api-route.yaml >/tmp/demo.log 2>&1  || true
sleep 2
export DATALAYER_ROUTE=$(oc get route  -n $AIOPS_NAMESPACE datalayer-api  -o jsonpath='{.status.ingress[0].host}')







#------------------------------------------------------------------------------------------------------------------------------------
#  Get Credentials
#------------------------------------------------------------------------------------------------------------------------------------
echo " "
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "   🚀  Initializing..."
echo "   ------------------------------------------------------------------------------------------------------------------------------"


echo "     📥 Get Date Formats"


OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" == "darwin" ]; then
      # Suppose we're on Mac
      export DATE_FORMAT_EVENTS="-v$EVENTS_SKEW +%Y-%m-%dT%H:%M:%S"
      #export DATE_FORMAT_EVENTS="+%Y-%m-%dT%H:%M"
else
      # Suppose we're on a Linux flavour
      export DATE_FORMAT_EVENTS="-d$EVENTS_SKEW +%Y-%m-%dT%H:%M:%S" 
      #export DATE_FORMAT_EVENTS="+%Y-%m-%dT%H:%M" 
fi

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "



while true;
do 
      for APP_NAME in "${ALL_APPS[@]}";
      do
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "     🚀  Injecting Events for $APP_NAME"
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"



            echo "     📥 Get Working Directories"
            export WORKING_DIR_EVENTS="./tools/01_demo/INCIDENT_FILES/$APP_NAME/events_rest"


            echo " "
            echo "       ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "         🔎  Parameters for Incident Simulation for $APP_NAME"
            echo "       ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "         "
            echo "           📅 Date Format Events          : $DATE_FORMAT_EVENTS"
            echo "           📅 Date                        : $(date $DATE_FORMAT_EVENTS))"
            
            echo "         "
            echo "           📂 Directory for Events        : $WORKING_DIR_EVENTS"
            echo "       "
            echo "           🗄️  Event Files to be loaded"
            ls -1 $WORKING_DIR_EVENTS | grep "json"| sed 's/^/                /'
            echo "     "
            echo "       ----------------------------------------------------------------------------------------------------------------------------------------"


            #---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            # RUNNING Injection
            #---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            # Inject the Events Inception files
            ./tools/01_demo/scripts/simulate-events-rest.sh


            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "     ⏳  Wait one minute - $(date '+%Y-%m-%dT%H:%M:%S')"
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"

            sleep 60


            export result=$(curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/stories" --insecure --silent -X PATCH -u "${USER_PASS}" -d '{"state": "resolved"}' -H 'Content-Type: application/json' -H "x-username:admin" -H "x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255")
            echo "       Stories closed: "$(echo $result | jq ".affected")

            #export result=$(curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/alerts?filter=type.classification%20%3D%20%27robot-shop%27" --insecure --silent -X PATCH -u "${USER_PASS}" -d '{"state": "closed"}' -H 'Content-Type: application/json' -H "x-username:admin" -H "x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255")
            export result=$(curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/alerts" --insecure --silent -X PATCH -u "${USER_PASS}" -d '{"state": "closed"}' -H 'Content-Type: application/json' -H "x-username:admin" -H "x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255")
            echo "       Alerts closed: "$(echo $result | jq ".affected")
            #curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/alerts" -X GET -u "${USER_PASS}" -H "x-username:admin" -H "x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255" | grep '"state": "open"' | wc -l


            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"
            echo "     ⏳  Wait one minute - $(date '+%Y-%m-%dT%H:%M:%S')"
            echo "   ----------------------------------------------------------------------------------------------------------------------------------------"

            sleep 60


      done

done

echo " "
echo " "
echo " "
echo " "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  IBMAIOPS Simulate Outage for $APP_NAME"
echo "  ✅  Done..... "
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"