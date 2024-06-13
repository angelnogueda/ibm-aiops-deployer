
export WORKING_DIR_LOGS=./templates/logs

export entityIDString="kubernetes.container_name"
export messagePayloadString="message"

export NODE_TLS_REJECT_UNAUTHORIZED=0

templateFile=$(<$WORKING_DIR_LOGS/template.tpl)
echo $templateFile

echo "">test.json

for actFile in $(ls -1 $WORKING_DIR_LOGS | grep "log");
do

    echo $actFile
    export componentName=${actFile%.*}
    echo $componentName
      if [[ $actFile =~ ".log" ]] ;
      then


      while IFS= read -r line
      do
        echo $line| sed 's/\\"/@@@@/g'| sed 's/\\/!!!!!!/g'|jq 
        #echo "${line//\\/\\\\}" |jq 
        
        entityID=$(jq -r ".$entityIDString" <<< "$line")
        echo $entityID
        messagePayload=$(echo $line | sed 's/\\"/@@@@/g'| sed 's/\\/!!!!!!/g'| jq ".$messagePayloadString")

        #messagePayload=$(jq ".$messagePayloadString" <<< "$line")
        echo "--------------------"
        echo "--------------------"
        echo "--------------------"

        echo $messagePayload
        

        #echo $templateFile | sed "s^{{entityID}}^$entityID^"| sed "s^{{messagePayload}}^$messagePayload^"   >>test.json
        echo "--------------------"
        echo "--------------------"
        echo "--------------------"
        echo $templateFile | sed "s^{{entityID}}^$entityID^g"| sed "s^{{messagePayload}}^$messagePayload^g" | sed 's/\"\"/\"/g'  >>test.json
        gsed -i 's/@@@@/\\\"/g' test.json
        #echo "${templateFile//@@entityID@@/$entityID}"


        #echo $templateFile | sed "s/{{entityID}}/$entityID/"| sed "s&{{messagePayload}}&${messagePayload}&"  #>>test.json
        #echo $line |jq ".$entityID"


        #echo "${line//\\\\/\\\\\\}" |jq ".$entityID"
        #echo $line|jq ".$entityID"

        #echo $line|jq ".$messagePayload"
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
