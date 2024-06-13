#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************"
echo "***************************************************************************************************************************************"
echo "   🚀  Inject Events"
echo "***************************************************************************************************************************************"


export APP_NAME=robot-shop
export LOG_TYPE=elk   # humio, elk, splunk, ...
export log_output_path=/dev/null 2>&1
export TYPE=events
export TYPE_PRINT="📥 "$(echo $TYPE | tr 'a-z' 'A-Z')

AIOPS_PARAMETER=$(cat ./00_config_ibm-aiops.yaml|grep AIOPS_NAMESPACE:)
AIOPS_NAMESPACE=${AIOPS_PARAMETER##*:}
AIOPS_NAMESPACE=$(echo $AIOPS_NAMESPACE|tr -d '[:space:]')







#--------------------------------------------------------------------------------------------------------------------------------------------
#  Launch Injection
#--------------------------------------------------------------------------------------------------------------------------------------------
echo "   "
echo "   "
echo "   --------------------------------------------------------------------------------------------------------------------------------"
echo "    🚀  Launching Injection"
echo "   --------------------------------------------------------------------------------------------------------------------------------"

for actFile in $(ls -1 $WORKING_DIR_EVENTS | grep "json");
do
    
    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Prepare the Data
    #--------------------------------------------------------------------------------------------------------------------------------------------
    
    echo "   ------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "     🛠️   Preparing Data for file $actFile"
    echo "   ------------------------------------------------------------------------------------------------------------------------------------------------"
    
    
    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Create file and structure in /tmp
    #--------------------------------------------------------------------------------------------------------------------------------------------
    mkdir /tmp/training-files-$TYPE/
    rm /tmp/training-files-$TYPE/x*
    cp $WORKING_DIR_EVENTS/$actFile /tmp/training-files-$TYPE/
    cd /tmp/training-files-$TYPE/
    
    
    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Update Timestamps
    #--------------------------------------------------------------------------------------------------------------------------------------------
    echo "       🔨 Updating Timestamps (this can take several minutes)"
    echo "   " > /tmp/timestampedErrorFiles-$TYPE.json
    while IFS= read -r line
    do
        # Get timestamp in ELK format
        export my_timestamp=$(date $DATE_FORMAT_EVENTS)
        # Replace in line
        line=${line//MY_TIMESTAMP/$my_timestamp}
        # Write line to temp file
        echo $line >> /tmp/timestampedErrorFiles-$TYPE.json
    done < "$actFile"
    echo "         ✅ OK"
    
    
    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Split the files in 1500 line chunks for kafkacat
    #--------------------------------------------------------------------------------------------------------------------------------------------
    echo "       🔨 Splitting"
    split -l 1500 /tmp/timestampedErrorFiles-$TYPE.json
    export NUM_FILES=$(ls | wc -l)
    rm $actFile
    rm /tmp/timestampedErrorFiles-$TYPE.json
    cd -
    echo "         ✅ OK"
    
    
    
    
    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Inject the Data
    #--------------------------------------------------------------------------------------------------------------------------------------------
    echo "   ------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "   🌏  Injecting Data from File: ${actFile}"
    echo "        Quit with Ctrl-Z"
    echo "   ------------------------------------------------------------------------------------------------------------------------------------------------"
    ACT_COUNT=0
    for FILE in /tmp/training-files-$TYPE/*; do
        if [[ $FILE =~ "x"  ]]; then
            ACT_COUNT=`expr $ACT_COUNT + 1`
            echo "   Injecting file ($ACT_COUNT/$(($NUM_FILES-1))) - $FILE"
            echo "                 ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $KAFKA_BROKER -P -t $KAFKA_TOPIC_EVENTS -l $FILE   "
            ${KAFKACAT_EXE} -v -X security.protocol=SASL_SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=$SASL_USER -X sasl.password=$SASL_PASSWORD -b $KAFKA_BROKER -P -t $KAFKA_TOPIC_EVENTS -l $FILE || true
            echo "         ✅ OK"
        fi
    done
done


