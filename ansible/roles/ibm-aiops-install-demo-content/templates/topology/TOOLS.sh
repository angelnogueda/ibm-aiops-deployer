            # fix sed issue on mac
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
        SED="sed"
        if [ "${OS}" == "darwin" ]; then
            SED="gsed"
            if [ ! -x "$(command -v ${SED})"  ]; then
            __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
            exit
            fi
        fi



    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})
    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"
    export LOGIN_TOKEN=$(echo -n $LOGIN|base64)
    export TOPO_MGT_HOST=$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    echo "    HOST:         $TOPO_MGT_HOST"
    echo "    URL:          $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN:        $LOGIN"
    echo "    LOGIN_TOKEN:  $LOGIN_TOKEN"

    kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- /opt/ibm/graph.tools/bin/backup_ui_config -out backup.json
    kubectl cp -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}'):/opt/ibm/netcool/asm/data/tools/backup.json ./backup.json
    #open ./backup.json

    echo "Upload Topology Customization"
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    if [[ "${OS}" == "darwin" ]]; then
          echo "MAC"
          TOPOLOGY_CUSTOM_FILE=$(pwd)"/roles/ibm-aiops-install-demo-content/templates/topology/asm_config.json"
    else
          TOPOLOGY_CUSTOM_FILE="{{role_path}}/templates/topology/asm_config.json"
    fi    

    cp $TOPOLOGY_CUSTOM_FILE /tmp/asm_config.json


    ${SED} -i -e "s/MY_TOPO_URL/$TOPO_MGT_HOST/g" /tmp/asm_config.json
    ${SED} -i -e "s/MY_TOKEN/$LOGIN_TOKEN/g" /tmp/asm_config.json
    cat /tmp/asm_config.json | grep MY_
open /tmp/asm_config.json 

    kubectl cp /tmp/asm_config.json -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}'):/opt/ibm/netcool/asm/data/tools/asm_config.json 
    

    echo "Import Topology Customization"
    #kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- find /opt/ibm/netcool/asm/data/tools/
    kubectl exec -ti -n $AIOPS_NAMESPACE $(oc get po -n $AIOPS_NAMESPACE|grep topology-topology|awk '{print$1}') -- /opt/ibm/graph.tools/bin/import_ui_config -file asm_config.json








curl 'https://cpd-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com/api/p/hdm_asm_ui_api/1.0/ui-api/http?target=https%3A%2F%2Ftopology-manage-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com%2F1.0%2Ftopology%2Fresources%2Fn7wW3HImQ1y3vagUaUSrLQ' \
-X 'POST' \
-H 'Content-Type: text/plain;charset=UTF-8' \
-H 'Accept: */*' \
-H 'Sec-Fetch-Site: same-origin' \
-H 'Accept-Language: en-US,en;q=0.9' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Sec-Fetch-Mode: cors' \
-H 'Host: cpd-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com' \
-H 'Origin: https://cpd-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Safari/605.1.15' \
-H 'Referer: https://cpd-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com/aiops/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/services/uXedwFYRSaudSVogRUlA5w/view?refreshTime=30000&viewStyle=topology' \
-H 'Content-Length: 17' \
-H 'Connection: keep-alive' \
-H 'Sec-Fetch-Dest: empty' \
-H 'Cookie: akora.sid=s%3AcIlihveeecR9kLaTKXIRyNmwCBQj9_kF.kdiDWPU5oQtMY5eXXbUzUbA%2BnhaX3TMsYTbU%2B8D2kUg; bm_sv=3D39A232FF93AAAE20E0C292B079FDE4~YAAQYQcQAu7N7eeOAQAAgUlcDxc6CdtUBPcMOwe+nDoF+n5Hb7QZEUk0k6wrdBLOn4EEwZxsTxEFmaY5arKHmXmt5Plz6O0UVa2ZVByIM28I82ZUzDSAu6FW+sIdEYek3TICNQE0ibTza0D4RajTlY11VmlJ0ED/rVquC6NWRH/Ur+tZNwadOEBuGu7fvKkceBwn0lg9zuvGMjM3hl7NYa+RfKy9LBMxZ7E3hmecKY36QssZMRjn/P9/kpb/gA==~1; notice_behavior=implied|eu; bm_sz=32F95EC30E4931F1DDAFC40E4C309543~YAAQCDdlX1LtTwuPAQAAKwJXDxeW2ylSJIQRwqdD6xHb0dvnUZebMun3JVQDAcEvK+h/vURmuxBh1iUANswyqNkFALPU2vkKJV+y+L1mpdzF4Y3lXM5QQuAIX+jm+SFepsiGsIXwVgw3tTEt8YSOYVAvy3MlGKpDgcF6qss9mJsjKbLEjXYz4slt/LjKiJCb3zer3Dty0mxTaZUAwPZTZYl2sLQglzUx4P8636uZwmezjniuJ4xUfwOKdfSsyyuFGk5xhZrH9qYkViXyCs8UriO1TpOfsk86Btpa38lG6b2M21COEa73vqran2sibS7rF6VWZZxvkSx3PToOI9R0PTdo0PjnpHFsMndNBWSROlrlLKKFSn+/9OptkIeKOp67frz6SfFRwfEJBAoOO3Z3LID5+zR9cGfbUCNsfbOEycvsFrQoGunhiZuIslfiY6zRSIDHKiqgjDd9M7AJ2Ml8jIM0IVyuYuSP9Kc=~4539462~3619125; _ga_FYECCCS21D=GS1.1.1713946896.15.1.1713949310.0.0.0; dtCookie=v_4_srv_5_sn_CF3AF02C6FB31D697A8B7EF54827A6F8_perc_100000_ol_0_mul_1_app-3Aea7c4b59f27d43eb_1_rcs-3Acss_0; dtPC=5$348476781_185h1vSEMPCFKHPTCWKSCCHSAKPPHWSHORAMTA-0e0; OPTOUTMULTI=0:0%7Cc1:1%7Cc2:0%7Cc3:0; _uetvid=2c370e50c43511ee972de31d17f472b0|1ivh13a|1713949308224|3|1|bat.bing.com/p/insights/c/a; dtSa=-; ga_visitor=Other IBM referrer|Organic|1; utag_main=v_id:018f017a668f002201054fd719fc05077007406f01328$_sn:11$_se:4$_ss:0$_st:1713951108646$is_country_requiring_explicit_consent:true$vapi_domain:ibm.com$dc_visit:11$ses_id:1713946881365%3Bexp-session$_pn:2%3Bexp-session$dc_event:1%3Bexp-session$dc_region:eu-central-1%3Bexp-session; rxVisitor=1713519001072EIQTU3HUG4SB51R5HB1C1MVNKABQ2EP3; _ga=GA1.1.1035815156.1713519199; AMCV_D10F27705ED7F5130A495C99%40AdobeOrg=359503849%7CMCIDTS%7C19837%7CMCMID%7C54590942999101790143056510225786320556%7CMCAAMLH-1714553277%7C6%7CMCAAMB-1714553277%7C6G1ynYcLPuiQxYZrsz_pkqfLG9yMXBpb2zX5dvJdYQJzPXImdj0y%7CMCOPTOUT-1713955677s%7CNONE%7CMCSYNCSOP%7C411-19842%7CvVersion%7C5.0.1%7CMCCIDH%7C-556261388; _uetsid=50d616e0fffd11eebbdb8d9006bd51b8|16y0kg3|2|fl7|0|1572; userContext=f0a43bd7-a3da-4d32-838a-6108e9c95e2e|0|0|0|NL|VD|1|2:|expressed|zz|n/a|n/a|n/a|n/a; pageviewContext=82957de6-4d75-4165-a074-346c83f421ac; rxvt=1713950276786|1713948476782; _abck=DD48F7701321DF43F52E3716CBDE177D~0~YAAQYQcQAmOU6OeOAQAAUCcyDwvpUrXMxpA+jiddByTsBpywkENmZnTG2gUPW0yXUtBxHi85WilX8oPmBJ4pQ1BFpYSUQULG/pMsJL5YKxp1HP5SFIofQEEvrVh+fwzIWuhmTsswpER12+I2WM4CYJWY9FHB8fM24Akw9ArH+SjwKBQ+ziuOACnoaZ3Q6JhUJyrnVBUsKkCRGSlby5fE4M403FWRET75XL4/Kugpjnip2g5nW1piqlAX1tJFY2GKId2Sz8LNPg+4PikuOzZLJNdtzgIIMsWFrODgbuZpbRJ9hYBtksBUNDrx1aY2zfU/schHGmMmVN38MzF9dMX1Ugd8VHZqGYR7JGaGGvoVtYRztdCXSPusdHBAPditirXzCq8NoIeFkMemBcu9KI/aD6TX7CNiow==~-1~-1~-1; ak_bmsc=EF04D3B6FB53DB647432BF49BF7DD535~000000000000000000000000000000~YAAQYQcQAnmU6OeOAQAA0icyDxcOpWNr0Z+Qtn46Pgs0weYp4sjmgDzFHMPHustNLhqakK+O9ZvTkkE+fff1j9wFfxdq1mhKnmjArNnk4f5ykanteaKxbEjjdR57e16BedVurHdlPEmj86eKFJFCeFs/4PdTz/tku+Icb46S9G+J1v2o4ee1BZn+IPNfwVw9Zx25jehCt1VTkn09ld5D6ymMlyQYS3KnMZeV2sDrBysJt2MddALwYy8SSX10qo5VUVU7NpyijpODPFrFWSepOeK1xIg9ZnO6HqVL3wxWsSqynSRrpYKa+9U70R03Jv22Lq84ZXNMVePjLxu1XIthjTNdhE8p/H+dW+uKX5PEYqllolBvry0x6HBTs5x2vA6G5XvxOXK3JQ==; connect.sid=s%3Akfho-jg71Ko-1kcPHoAQJc-ZAm_zA0AD.bZHPnApnQcZyLTpf%2F02VDnAXuZgdJyoE7iA%2FtT47zXc; ibm-private-cloud-session-id=4fb98d30-1bf1-4514-831a-9738c4138fa9; loginType=LDAP; ajs_anonymous_id=f0a43bd7-a3da-4d32-838a-6108e9c95e2e; ajs_user_id=IBMid-270003BU3K; _gid=GA1.2.1120328582.1713717394; ___tk67142224=1713931413186; gaVisitor=Organic|Referral; BMAID=f0a43bd7-a3da-4d32-838a-6108e9c95e2e; CISESSIONIDPR07A=PBC5YS:1084701854; AMCVS_D10F27705ED7F5130A495C99%40AdobeOrg=1; CISESSIONIDPR07B=PBC5YS:2118599878; notice_gdpr_prefs=0|1|2:; notice_preferences=2:; 0b08caf8fa955e3899999d491a69f133=c2645e19c17c0009694398d3771be50f' \
-H 'asm-proxy-X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
-H 'asm-proxy-Content-type: application/json' \
-H 'asm-proxy-Authorization: Basic ddddd' \
--data-binary '{ "gggg": "gggg"}'

var name = prompt("property name", "name");
var value = prompt("property value", "value");
var options = {
    method: 'POST',
    headers: {
        "X-TenantID": "cfd95b7e-3bc7-4006-a4a8-a73a79c71255",
        "Authorization": "Basic xxxx",
        "Content-type": "application/json"
    },
    body: '{ "' + name + '": "' + value + '"}',
    onSuccess: _onSuccess,
    onError: _onError
};
asmFunctions.sendHttpRequest('https://topology-manage-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com/1.0/topology/resources/' + asmProperties._id, options);

function _onSuccess(response, status, headers) {
  asmFunctions.showToasterMessage("normal", "Resource updated.")
}

function _onError(response, status, headers) {
  var msg = JSON.parse(response);
  asmFunctions.showToasterMessage("critical", msg._error.description );
}

https://topology-manage-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com/1.0/topology/resources/



var name = prompt("property name", "name");
var value = prompt("property value", "value");
var options = {
    method: 'POST',
    headers: {
        "X-TenantID": "cfd95b7e-3bc7-4006-a4a8-a73a79c71255",
        "Authorization": "Basic xxx",
        "Content-type": "application/json"
    },
    body: '{ "' + name + '": "' + value + '"}',
    onSuccess: _onSuccess,
    onError: _onError
};
asmFunctions.sendHttpRequest('https://topology-manage-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com/1.0/topology/resources/' + asmProperties._id, options);

function _onSuccess(response, status, headers) {
  asmFunctions.showToasterMessage("normal", "Resource updated.")
}

function _onError(response, status, headers) {
  var msg = JSON.parse(response);
  asmFunctions.showToasterMessage("critical", msg._error.description );
}



var name = prompt("Name", "name");
var type = prompt("Type", "host");
var edgeType = prompt("Edge type", "connectedTo");
var toOrFrom = prompt("Edge 'to' or 'from' the selected node?", "to");
var options = {
    method: 'POST',
    headers: {
        "X-TenantID": "cfd95b7e-3bc7-4006-a4a8-a73a79c71255",
        "Authorization": "Basic xxxx",
        "Content-type": "application/json"
    },
    body: '{ "name":"' + name + '", "entityTypes": ["' + type + '"], "_references":[{"_' + toOrFrom + 'Id": "' + asmProperties._id +'","_edgeType": "' + edgeType + '"}]}',
    onSuccess: _onSuccess,
    onError: _onError
};
asmFunctions.sendHttpRequest('https://topology-manage-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com/1.0/topology/resources/', options);


function _onSuccess(response, status, headers) {
    asmFunctions.showToasterMessage('information', status + ': Created resource ' + headers.entityid);
}
function _onError(response, status, headers) {
  var msg = JSON.parse(response);
  asmFunctions.showToasterMessage("critical", msg._error.description );
}





var options = {
    method: 'DELETE',
    headers: {
        "X-TenantID": "cfd95b7e-3bc7-4006-a4a8-a73a79c71255",
        "Authorization": "Basic xxx",
        "Content-type": "application/json"
    },
    onSuccess: _onSuccess,
    onError: _onError
};
asmFunctions.sendHttpRequest('https://topology-manage-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com/1.0/topology/resources/' + asmProperties._id, options);

function _onSuccess(response, status, headers) {
  asmFunctions.showToasterMessage("Information", "Resource '" + asmProperties.name + "' deleted.")
}

function _onError(response, status, headers) {
  var msg = JSON.parse(response);
  asmFunctions.showToasterMessage("critical", msg._error.description );
}



https://topology-manage-ibm-aiops.apps.65f9b2d7888b49001e275e92.cloud.techzone.ibm.com




