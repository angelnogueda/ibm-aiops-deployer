
export INDEX_DATE=$(date +%Y%m%d)
export SED="gsed"


export CURRENT_FILE=1000-1000-xxxxxxxx-logtrain.json
export OUTPUT_FILE=1000-1000-$INDEX_DATE-logtrain.json

cp $CURRENT_FILE /tmp/es_logs_temp.json
${SED} -i "s/INDEX_DATE/$INDEX_DATE/g" /tmp/es_logs_temp.json

echo ""> /tmp/$OUTPUT_FILE

export COUNTER=0
export TIMESTAMP_DATE_EPOCH=$(date +%s)



while true; do
        echo "MESSAGE_DATE:$MESSAGE_DATE"
        echo "TIMESTAMP_DATE_EPOCH:$TIMESTAMP_DATE_EPOCH"

    while read -r line; do 

        export TIMESTAMP_DATE_EPOCH=$((TIMESTAMP_DATE_EPOCH+1))
        export MESSAGE_DATE=$(date -j -f %s  $TIMESTAMP_DATE_EPOCH  +%d/%b/%Y:%H:%M:%S)

        echo $line|${SED} -e "s/TIMESTAMP_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/"|${SED} -e "s%MESSAGE_DATE%$MESSAGE_DATE%g" |${SED} -e "s/MESSAGE_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/">>/tmp/$OUTPUT_FILE

    done < /tmp/es_logs_temp.json
done

cat /tmp/$OUTPUT_FILE



































export CURRENT_FILE=1000-1000-xxxxxxxx-logtrain.json

cat $CURRENT_FILE

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
SED="sed"
if [ "${OS}" == "darwin" ]; then
    SED="gsed"
    if [ ! -x "$(command -v ${SED})"  ]; then
    __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
    exit
    fi
fi


for CURRENT_FILE in $(ls -1 . | grep "json");
do
    echo $actFile
    cat $actFile|jq '._source.instance_id' | sort | uniq -c
done


export INDEX_DATE=$(date +%Y-%m-%d_%H:%M)

# 20231020
export INDEX_DATE=$(date +%Y%m%d)


export TIMESTAMP_DATE_EPOCH=$(date +%s)"000"
export MESSAGE_DATE_EPOCH=$TIMESTAMP_DATE_EPOCH

# [20/Oct/2023:07:48:49 +0000]
export MESSAGE_DATE="["$(date +%d/%b/%Y:%H:%M:%S)" +0000]"


echo "INDEX_DATE:$INDEX_DATE"
echo "TIMESTAMP_DATE_EPOCH:$TIMESTAMP_DATE_EPOCH"
echo "MESSAGE_DATE_EPOCH:$MESSAGE_DATE_EPOCH"
echo "MESSAGE_DATE:$MESSAGE_DATE"

cp $CURRENT_FILE /tmp/es_logs_temp.json

${SED} -i "s/INDEX_DATE/$INDEX_DATE/g" /tmp/es_logs_temp.json

cat /tmp/es_logs_temp.json


while read -r line; do 

export TIMESTAMP_DATE_EPOCH=$(date +%s)"000"
export MESSAGE_DATE_EPOCH=$TIMESTAMP_DATE_EPOCH
export MESSAGE_DATE="["$(date +%d/%b/%Y:%H:%M:%S)" +0000]"
${SED} -i "s/TIMESTAMP_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/g" /tmp/es_logs_temp.json
${SED} -i "s/MESSAGE_DATE_EPOCH/$MESSAGE_DATE_EPOCH/g" /tmp/es_logs_temp.json
${SED} -i "s/MESSAGE_DATE/$MESSAGE_DATE/g" /tmp/es_logs_temp.json


done < $CURRENT_FILE


cat /tmp/es_logs_temp.json


| ${SED} -e 's/,"raw_data":{.*}}}/}}/' > /tmp/snowchangerequest2.json


export COUNTER=0
echo ""> /tmp/es_logs_temp_date.json

export TIMESTAMP_DATE_EPOCH=$(date +%s)"000"
export MESSAGE_DATE_EPOCH=$TIMESTAMP_DATE_EPOCH
export MESSAGE_DATE="["$(date -j -f %s  $TIMESTAMP_DATE_EPOCH  +%d/%b/%Y:%H:%M:%S)" +0000]"













export INDEX_DATE=$(date +%Y%m%d)
export SED="gsed"


export CURRENT_FILE=1000-1000-xxxxxxxx-logtrain.json
export OUTPUT_FILE=1000-1000-$INDEX_DATE-logtrain.json

cp $CURRENT_FILE /tmp/es_logs_temp.json
${SED} -i "s/INDEX_DATE/$INDEX_DATE/g" /tmp/es_logs_temp.json

echo ""> /tmp/$OUTPUT_FILE




export COUNTER=0
export TIMESTAMP_DATE_EPOCH=$(date +%s)

while read -r line; do 


COUNTER=$((COUNTER+1))
echo $COUNTER

export TIMESTAMP_DATE_EPOCH=$((TIMESTAMP_DATE_EPOCH+1))
export MESSAGE_DATE=$(date -j -f %s  $TIMESTAMP_DATE_EPOCH  +%d/%b/%Y:%H:%M:%S)
echo "INDEX_DATE:$INDEX_DATE"
echo "TIMESTAMP_DATE_EPOCH:$TIMESTAMP_DATE_EPOCH"
echo "MESSAGE_DATE:$MESSAGE_DATE"

echo $line|${SED} -e "s/TIMESTAMP_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/"|${SED} -e "s%MESSAGE_DATE%$MESSAGE_DATE%g" |${SED} -e "s/MESSAGE_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/">>/tmp/$OUTPUT_FILE



done < /tmp/es_logs_temp.json


cat /tmp/$OUTPUT_FILE



echo $line|${SED} -e "s/TIMESTAMP_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/"|${SED} -e "s%MESSAGE_DATE%$MESSAGE_DATE%" |${SED} -e "s/MESSAGE_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/">>/tmp/es_logs_temp_date.json


echo $line|${SED} -e "s/TIMESTAMP_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/"|${SED} -e "s/MESSAGE_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/"|${SED} -e "s@MESSAGE_DATE@${MESSAGE_DATE}@" 



echo '{"_index":"1000-1000-INDEX_DATE-logtrain","_type":"_doc","_id":"-118612029","_score":1,"_source":{"message":"[ 07:50:48,661] INFO in payment: queue order","full_message":"[MESSAGE_DATE 07:50:48,661] INFO in payment: queu'|${SED} -e "s/TIMESTAMP_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/"|${SED} -e "s/MESSAGE_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/"|${SED} -e "s@MESSAGE_DATE@${MESSAGE_DATE}@"

export MESSAGE_DATE="["$(date -j -f %s  1697795360251  +%d/%b/%Y:%H:%M:%S)" +0000]"




${SED} -i "s/TIMESTAMP_DATE_EPOCH/$TIMESTAMP_DATE_EPOCH/g" /tmp/es_logs_temp.json
${SED} -i "s/MESSAGE_DATE_EPOCH/$MESSAGE_DATE_EPOCH/g" /tmp/es_logs_temp.json
${SED} -i "s/MESSAGE_DATE/${MESSAGE_DATE/g" /tmp/es_logs_temp.json



2023-10-20 07:51:39.857


{
    "_index": "1000-1000-INDEX_DATE-logtrain",
    "_type": "_doc",
    "_id": "-194765916",
    "_score": 1,
    "_source": {
        "message": "2023-10-20 07:51:39.857  INFO 1 --- [nio-8080-exec-1] c.instana.robotshop.shipping.Controller  : Calculation for 3304114",
        "full_message": "2023-10-20 07:51:39.857  INFO 1 --- [nio-8080-exec-1] c.instana.robotshop.shipping.Controller  : Calculation for 3304114",
        "instance_id": "robot-shop",
        "entities": {
            "unique-id": "shipping",
            "kubernetes-container_image_id": "quay.io/niklaushirt/rs-shipping@sha256:89753ab489193286402c9486379da63c18a21d697b4fbd41246b68aacabfc6d3",
            "kubernetes-host": "worker-3",
            "kubernetes-pod_name": "shipping-86bcfc45d5-xd54g",
            "kubernetes-namespace_name": "robot-shop"
        },
        "type": "null",
        "la_golden_signals_template": "unmatched_information",
        "application_group_id": "1000",
        "application_id": "1000",
        "meta_features": [{
            "type": "WindowMeta",
            "obj_value": {
                "start": 1697788290000,
                "end": 1697788300000
            }
        }],
        "timestamp": TIMESTAMP_DATE,
        "elastic_index_id": -194765916
    }
}

