
export WORKING_DIR_LOGS=./templates/logs

export NODE_TLS_REJECT_UNAUTHORIZED=0

for actFile in $(ls -1 $WORKING_DIR_LOGS | grep "log");
do

    echo $actFile
    export componentName=${actFile%.*}
    echo $componentName
      if [[ $actFile =~ ".log" ]] ;
      then


    while IFS=';' read -r id rest; do
        if [[ "$id" == "10010101010" ]]; then
            echo "Matching line : $id $rest"
        fi
    done < "$WORKING_DIR_LOGS/$actFile"


      while IFS= read -r line
      do
        echo $line
      done < "$WORKING_DIR_LOGS/$actFile"
      echo "              ✅ OK"
      echo " "
      fi
done



exit 1


            COUNTER=$((COUNTER+1))
            EVENTS_SECONDS=$((EVENTS_SECONDS+1))
            EVENTS_SECONDS=$((EVENTS_SECONDS+60))
            EVENTS_SECONDS_SKEW="-v+"$EVENTS_SECONDS"S"

            # Get timestamp in ELK format
            export my_timestamp=$(date $EVENTS_SECONDS_SKEW $DATE_FORMAT_EVENTS)".000Z"
            export myID=$(date "+%s")$COUNTER

            #echo "aaaaa: "$myID
            # Replace in line
            line=${line//MY_TIMESTAMP/$my_timestamp}
            line=${line//MY_ID/$myID}
            line=${line//\"/\\\"}

            #echo "       Q:$myID"

            export c_string=$(echo "curl \"https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/events\" --insecure -s  -X POST -u \"${USER_PASS}\" -H 'Content-Type: application/json' -H 'x-username:admin' -H 'x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d \"${line}\"")
            #echo "       Q:$c_string"
            export result=$(eval $c_string)
            #export result=$(curl "https://$DATALAYER_ROUTE/irdatalayer.aiops.io/active/v1/events" --insecure --silent -X POST -u "${USER_PASS}" -H 'Content-Type: application/json' -H "x-username:admin" -H "x-subscription-id:cfd95b7e-3bc7-4006-a4a8-a73a79c71255" -d "${line}")
            myId=$(echo $result|jq ".deduplicationKey")
            echo "              DONE:$myId"
            #echo "       DONE:$result"
