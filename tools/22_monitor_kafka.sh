#!/bin/bash
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
#  IBMAIOPS - Monitor Kafka Topics
#
#
#  ©2024 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
clear

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 IBM AIOps - Monitor Kafka Topics"
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "
export TEMP_PATH=~/aiops-install

echo "  Initializing......"



export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

export LOG_TYPE=elk   # humio, elk, splunk, ...
export EVENT_TYPE=noi   # humio, elk, splunk, ...











































#!/bin/bash
menu_option_1 () {
  echo "Kafka Topics"
  oc get kafkatopic -n $AIOPS_NAMESPACE

}

menu_option_2() {
  echo "Monitor Incidents"
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -o -200 -C -t cp4waiops-cartridge.lifecycle.input.alerts

}


menu_option_3() {
  echo "Monitor Incidents"
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -o -200 -C -t cp4waiops-cartridge.lifecycle.input.stories 

}


menu_option_4() {
  echo "Monitor Events $EVENTS_TOPIC"
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -o -200 -C -t $EVENTS_TOPIC

}


menu_option_5() {
  echo "Monitor Logs $LOGS_TOPIC"
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -o -200 -C -t $LOGS_TOPIC 

}


menu_option_6() {
  echo "Monitor Metrics Ingestion"
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -C -t cp4waiops-cartridge.analyticsorchestrator.metrics.itsm.raw

}


menu_option_7() {
  echo "Monitor Alerts"
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -o -200 -C -t cp4waiops-cartridge.lifecycle.input.alerts

}

menu_option_8() {
  echo "Instana Connector Response"
  
  echo "	Press CTRL-C to stop "

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -o -200 -C -t cp4waiops-cartridge.connector-instana.infra_topology.connector_response

}


menu_option_9() {
  echo "Monitor Specific Topic"
  oc get kafkatopic -n $AIOPS_NAMESPACE
  echo "     📥 Get Kafka Topics"
  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -L -J| jq -r '.topics[].topic' 

  read -p "Copy Paste Topic from above: " MY_TOPIC

  ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -o -200 -C -t $MY_TOPIC
}




clear



echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 IBM AIOps - Monitor Kafka Topics"
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "

echo "  Initializing......"
if [ -x "$(command -v kafkacat)" ]; then
    export KAFKACAT_EXE=kafkacat
else
    if [ -x "$(command -v kcat)" ]; then
        export KAFKACAT_EXE=kcat
    else
        echo "      ❗ ERROR: kafkacat/kcat is not installed."
        echo "      ❌ Aborting..."
        exit 1
    fi
fi

  oc extract secret/kafka-secrets -n $AIOPS_NAMESPACE --keys=ca.crt --confirm
  export KAFKA_SECRET=$(oc get secret -n $AIOPS_NAMESPACE |grep 'aiops-kafka-secret'|awk '{print$1}')

  export SASL_USER=$(oc get secret $KAFKA_SECRET -n $AIOPS_NAMESPACE --template={{.data.username}} | base64 --decode)
  export SASL_PASSWORD=$(oc get secret $KAFKA_SECRET -n $AIOPS_NAMESPACE --template={{.data.password}} | base64 --decode)
  export BROKER=$(oc get routes iaf-system-kafka-0 -n $AIOPS_NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443



echo "***************************************************************************************************************************************************"
echo "  "

export LOGS_TOPIC=$(${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -L -J| jq -r '.topics[].topic' | grep cp4waiops-cartridge-logs-elk| head -n 1)
export EVENTS_TOPIC=$(${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $BROKER -L -J| jq -r '.topics[].topic' | grep lifecycle.input.events| head -n 1)





until [ "$selection" = "0" ]; do
  
  
  echo "  🔎 Observe Kafka Topics "
  echo "    	1  - Get Kafka Topics"
  echo "    	2  - Monitor Alerts"
  echo "    	3  - Monitor Incidents"
  echo "    	4  - Monitor Events $EVENTS_TOPIC"
  echo "    	5  - Monitor Logs $LOGS_TOPIC"
  echo "    	6  - Monitor Metrics Ingestion"
  #echo "    	7  - Monitor Alerts"
  #echo "    	8  - Monitor Instana Connector Response"
  echo "    	9  - Monitor Specific Topic"
  echo "      "
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; menu_option_1  ;;
    2 ) clear ; menu_option_2  ;;
    3 ) clear ; menu_option_3  ;;
    4 ) clear ; menu_option_4  ;;
    5 ) clear ; menu_option_5  ;;
    6 ) clear ; menu_option_6  ;;
    7 ) clear ; menu_option_7  ;;
    8 ) clear ; menu_option_8  ;;
    9 ) clear ; menu_option_9  ;;

    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection  ;;
  esac
done







