import requests
from requests.auth import HTTPBasicAuth
import json
import datetime
import random
import os
import time
from pathlib import Path
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
print ('')
print ('')
print ('')
print ('')
print ('')
print ('')
print ('')
print ('')
print ('*************************************************************************************************')
print ('*************************************************************************************************')
print ('            ________  __  ___     ___    ________       ')
print ('           /  _/ __ )/  |/  /    /   |  /  _/ __ \____  _____')
print ('           / // __  / /|_/ /    / /| |  / // / / / __ \/ ___/')
print ('         _/ // /_/ / /  / /    / ___ |_/ // /_/ / /_/ (__  ) ')
print ('        /___/_____/_/  /_/    /_/  |_/___/\____/ .___/____/  ')
print ('                                              /_/')
print ('*************************************************************************************************')
print ('*************************************************************************************************')
print ('')
print ('    🛰️  DemoUI for IBM Automation AIOps')
print ('')
print ('       Provided by:')
print ('        🇨🇭 Niklaus Hirt (nikh@ch.ibm.com)')
print ('')
print ('*************************************************************************************************')
print ('*************************************************************************************************')
print ('')
print ('')
print ('')
print ('')
print ('')
print ('-------------------------------------------------------------------------------------------------')
print (' 🚀 Prefetching Configuration')
print ('-------------------------------------------------------------------------------------------------')

# ----------------------------------------------------------------------------------------------------------------------------------------------------
# DEFAULT VALUES
# ----------------------------------------------------------------------------------------------------------------------------------------------------
LOG_ITERATIONS=5
TOKEN='test'
LOG_TIME_FORMAT="%Y-%m-%dT%H:%M:%S.000000"
LOG_TIME_STEPS=1000
LOG_TIME_SKEW=60
LOG_TIME_ZONE="-1"


#ROBOTSHOP
DEMO_EVENTS_MEM=os.environ.get('DEMO_EVENTS_MEM')
DEMO_EVENTS_TUBE=os.environ.get('DEMO_EVENTS_TUBE','')
DEMO_EVENTS_TELCO=os.environ.get('DEMO_EVENTS_TELCO','')
DEMO_LOGS=os.environ.get('DEMO_LOGS')
DEMO_LOGS_SOCK=os.environ.get('DEMO_LOGS_SOCK')
METRICS_TO_SIMULATE_MEM=str(os.environ.get('METRICS_TO_SIMULATE_MEM')).split(';')
METRICS_TO_SIMULATE_FAN_TEMP=str(os.environ.get('METRICS_TO_SIMULATE_FAN_TEMP')).split(';')
METRICS_TO_SIMULATE_FAN=str(os.environ.get('METRICS_TO_SIMULATE_FAN')).split(';')
METRICS_TO_SIMULATE_NET=str(os.environ.get('METRICS_TO_SIMULATE_NET')).split(';')

ROBOTSHOP_PROPERTY_RESOURCE_NAME=os.environ.get('ROBOTSHOP_PROPERTY_RESOURCE_NAME','mysql')
ROBOTSHOP_PROPERTY_RESOURCE_TYPE=os.environ.get('ROBOTSHOP_PROPERTY_RESOURCE_TYPE','deployment')
ROBOTSHOP_PROPERTY_VALUES_NOK=os.environ.get('ROBOTSHOP_PROPERTY_VALUES_NOK','{"innodb_buffer_pool_size": "8GB","last_change_by": "Niklaus Hirt"}')
ROBOTSHOP_PROPERTY_VALUES_OK=os.environ.get('ROBOTSHOP_PROPERTY_VALUES_OK','{"innodb_buffer_pool_size": "8GB","last_change_by": "Scott James"}')



#ACME
METRICS_TO_SIMULATE_FAN_TEMP_ACME=str(os.environ.get('METRICS_TO_SIMULATE_FAN_TEMP_ACME')).split(';')
METRICS_TO_SIMULATE_FAN_ACME=str(os.environ.get('METRICS_TO_SIMULATE_FAN_ACME')).split(';')
DEMO_EVENTS_FAN_ACME=os.environ.get('DEMO_EVENTS_FAN_ACME')


#SOCKESHOP
METRICS_TO_SIMULATE_NET_SOCK=str(os.environ.get('METRICS_TO_SIMULATE_NET_SOCK')).split(';')
DEMO_EVENTS_NET_SOCK=os.environ.get('DEMO_EVENTS_NET_SOCK')

#BUSY
DEMO_EVENTS_BUSY=os.environ.get('DEMO_EVENTS_BUSY','')

#CUSTOM
CUSTOM_NAME=os.environ.get('CUSTOM_NAME','Custom Scenario')
CUSTOM_EVENTS=os.environ.get('CUSTOM_EVENTS','')
CUSTOM_METRICS=str(os.environ.get('CUSTOM_METRICS')).split(';')
CUSTOM_LOGS=os.environ.get('CUSTOM_LOGS','')
CUSTOM_TOPOLOGY=os.environ.get('CUSTOM_TOPOLOGY','')
CUSTOM_TOPOLOGY_TAG=os.environ.get('CUSTOM_TOPOLOGY_TAG','')
CUSTOM_TOPOLOGY_APP_NAME=os.environ.get('CUSTOM_TOPOLOGY_APP_NAME','')
CUSTOM_TOPOLOGY_FORCE_RELOAD=os.environ.get('CUSTOM_TOPOLOGY_FORCE_RELOAD','False')

CUSTOM_PROPERTY_RESOURCE_NAME=os.environ.get('CUSTOM_PROPERTY_RESOURCE_NAME','')
CUSTOM_PROPERTY_RESOURCE_TYPE=os.environ.get('CUSTOM_PROPERTY_RESOURCE_TYPE','')
CUSTOM_PROPERTY_VALUES_NOK=os.environ.get('CUSTOM_PROPERTY_VALUES_NOK','')
CUSTOM_PROPERTY_VALUES_OK=os.environ.get('CUSTOM_PROPERTY_VALUES_OK','')




#SHOW CONFIG
GET_CONFIG=str(os.environ.get('GET_CONFIG', "false"))


# GLOBAL
METRIC_TIME_SKEW=int(os.environ.get('METRIC_TIME_SKEW'))
METRIC_TIME_STEP=int(os.environ.get('METRIC_TIME_STEP'))
METRIC_ITERATIONS=int(os.environ.get('METRIC_ITERATIONS', "80"))

LOG_ITERATIONS=int(os.environ.get('LOG_ITERATIONS'))
LOG_TIME_FORMAT=os.environ.get('LOG_TIME_FORMAT')
LOG_TIME_STEPS=int(os.environ.get('LOG_TIME_STEPS'))
LOG_TIME_SKEW=int(os.environ.get('LOG_TIME_SKEW'))
LOG_TIME_ZONE=int(os.environ.get('LOG_TIME_ZONE'))

EVENTS_TIME_SKEW=int(os.environ.get('EVENTS_TIME_SKEW'))

INSTANCE_NAME=os.environ.get('INSTANCE_NAME')
if INSTANCE_NAME == None:
    INSTANCE_NAME="IBMAIOPS"

image_name=INSTANCE_NAME.lower().replace(" ", "_")+".png"
path = Path('./static/images/characters/'+image_name)

if path.is_file():
    #print('Custom Image:'+str(path))
    INSTANCE_IMAGE=path
else:
    INSTANCE_IMAGE="None"



SLACK_URL_ROSH=str(os.environ.get('SLACK_URL_ROSH', "NONE"))
SLACK_URL_SOSH=str(os.environ.get('SLACK_URL_SOSH', "NONE"))
SLACK_URL_ACME=str(os.environ.get('SLACK_URL_ACME', "NONE"))

SNOW_URL_ROSH=str(os.environ.get('SNOW_URL_ROSH', "NONE"))
SNOW_URL_SOSH=str(os.environ.get('SNOW_URL_SOSH', "NONE"))
SNOW_URL_ACME=str(os.environ.get('SNOW_URL_ACME', "NONE"))

INCIDENT_URL_TUBE=str(os.environ.get('INCIDENT_URL_TUBE', "NONE"))


print (' ✅ Prefetching Configuration - DONE')
print ('-------------------------------------------------------------------------------------------------')
print ('')
print ('')


# ----------------------------------------------------------------------------------------------------------------------------------------------------
# CLOSE ALERTS AND STORIES
# ----------------------------------------------------------------------------------------------------------------------------------------------------
def mitigateIssues(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):
    print ('📛 START - mitigateIssues')
    print('🌏 Reset RobotShop MySQL outage')
    os.system('oc patch service mysql -n robot-shop --patch "{\\"spec\\": {\\"selector\\": {\\"service\\": \\"mysql\\"}}}"')
    os.system('oc set env deployment ratings -n robot-shop PDO_URL-')
    os.system('oc set env deployment load -n robot-shop ERROR=0')
    os.system("oc delete pod $(oc get po -n robot-shop|grep shipping|awk '{print$1}') -n robot-shop --ignore-not-found")
    print('🌏 Mitigate Sockshop Catalog outage')
    os.system('oc patch service catalogue -n sock-shop --patch "{\\"spec\\": {\\"selector\\": {\\"name\\": \\"catalog\\"}}}"')



    print ('✅ END - mitigateIssues')

    return 'OK'


def closeAlerts(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):
    print ('📛 START - Close Alerts')
    data = '{"state": "closed"}'
    url = 'https://'+DATALAYER_ROUTE+'/irdatalayer.aiops.io/active/v1/alerts'
    auth=HTTPBasicAuth(DATALAYER_USER, DATALAYER_PWD)
    headers = {'Content-Type': 'application/json', 'Accept-Charset': 'UTF-8', 'x-username' : 'admin', 'x-subscription-id' : 'cfd95b7e-3bc7-4006-a4a8-a73a79c71255'}
    try:
        response = requests.patch(url, data=data, headers=headers, auth=auth, verify=False)
    except requests.exceptions.RequestException as e:  # This is the correct syntax
        stream = os.popen("oc get route  -n "+aimanagerns+" datalayer-api  -o jsonpath='{.status.ingress[0].host}'")
        print('     ❗ YOU MIGHT WANT TO USE THE DATALAYER PUBLIC ROUTE: '+str(stream.read().strip()))
        raise SystemExit(e)

    print ('    Close Alerts:'+str(response.content))
    print ('✅ END - Close Alerts')

    return 'OK'


def closeStories(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):
    print('')
    dataInProgress = '{"state": "inProgress"}'
    dataResolved = '{"state": "resolved"}'
    url = 'https://'+DATALAYER_ROUTE+'/irdatalayer.aiops.io/active/v1/stories'
    auth=HTTPBasicAuth(DATALAYER_USER, DATALAYER_PWD)
    headers = {'Content-Type': 'application/json', 'Accept-Charset': 'UTF-8', 'x-username' : 'admin', 'x-subscription-id' : 'cfd95b7e-3bc7-4006-a4a8-a73a79c71255'}
    print ('📛 START - Set Stories to InProgress')
    try:
        response = requests.patch(url, data=dataInProgress, headers=headers, auth=auth, verify=False)
    except requests.exceptions.RequestException as e:  # This is the correct syntax
        stream = os.popen("oc get route  -n "+aimanagerns+" datalayer-api  -o jsonpath='{.status.ingress[0].host}'")
        print('     ❗ YOU MIGHT WANT TO USE THE DATALAYER PUBLIC ROUTE: '+str(stream.read().strip()))
        raise SystemExit(e)

    time.sleep(10)
    print ('📛 START - Set Stories to Resolved')
    try:
        response = requests.patch(url, data=dataResolved, headers=headers, auth=auth, verify=False)
    except requests.exceptions.RequestException as e:  # This is the correct syntax
        stream = os.popen("oc get route  -n "+aimanagerns+" datalayer-api  -o jsonpath='{.status.ingress[0].host}'")
        print('     ❗ YOU MIGHT WANT TO USE THE DATALAYER PUBLIC ROUTE: '+str(stream.read().strip()))
        raise SystemExit(e)
    
    print ('    Close Stories-:'+str(response.content))
    print ('✅ END - Close Stories')

    return 'OK'



# ----------------------------------------------------------------------------------------------------------------------------------------------------
# INJECT LOGS
# ----------------------------------------------------------------------------------------------------------------------------------------------------
from confluent_kafka import Producer
import socket

def injectLogsRobotShop(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,DEMO_LOGS): 
    print ('📛 START - Inject Logs CONT - ROBOTSHOP')
    injectLogsContinuous(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,DEMO_LOGS)
    return 'OK'


def injectLogsSockShop(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,DEMO_LOGS_SOCK):  
    print ('📛 START - Inject Logs - SOCKSHOP')
    LOG_TIME_FORMAT="%Y-%m-%d %H:%M:%S.000"
    injectLogsGeneric(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,DEMO_LOGS_SOCK)
    return 'OK'


def injectLogsCUSTOM(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,CUSTOM_LOGS):  
    print ('📛 START - Inject Logs - CUSTOM_LOGS')
    LOG_TIME_FORMAT="%Y-%m-%d %H:%M:%S.000"
    injectLogsGeneric(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,CUSTOM_LOGS)
    return 'OK'



def injectLogsContinuous(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,DEMO_LOGS_GENERIC):

    stream = os.popen('echo "'+KAFKA_CERT+'" > ./demouiapp/ca.crt')
    stream.read().strip()

    print ('    📛 KAFKA_BROKER  :'+str(KAFKA_BROKER)+':')

    try:

        conf = {'bootstrap.servers': KAFKA_BROKER,
                'security.protocol': "SASL_SSL",
                'sasl.mechanisms': 'SCRAM-SHA-512',
                'sasl.username': KAFKA_USER,
                'sasl.password': KAFKA_PWD,
                'client.id': socket.gethostname(),
                'enable.ssl.certificate.verification': 'false',
                'ssl.ca.location': './demouiapp/ca.crt'
                }

    #ssl.ca.location
        producer = Producer(conf)

        for i in range (1,LOG_ITERATIONS):
            for line in DEMO_LOGS_GENERIC.split('\n'):
                timestamp = datetime.datetime.now()
                timestamp = timestamp + datetime.timedelta(minutes=LOG_TIME_SKEW)
                timestampstr = timestamp.strftime(LOG_TIME_FORMAT)+'+00:00'
                line = line.replace("MY_TIMESTAMP", timestampstr).strip()
                #print ('    XX:'+line)
                producer.produce(KAFKA_TOPIC_LOGS, value=line)

                # stream = os.popen("oc get route  -n "+aimanagerns+" datalayer-api  -o jsonpath='{.status.ingress[0].host}'")
                # print('     ❗ YOU MIGHT WANT TO USE THE DATALAYER PUBLIC ROUTE: '+str(stream.read().strip()))
                time.sleep((LOG_TIME_STEPS/10000))
            producer.flush()
            print('    📝 Logs-Injection: '+str(i)+'  :  '+str(timestamp))
            time.sleep(5)
    except KafkaException as e:
        print( "Kafka: "+str(e) )
    print ('✅ END - Inject Logs')

    return 'OK'



def injectLogsGeneric(KAFKA_BROKER,KAFKA_USER,KAFKA_PWD,KAFKA_TOPIC_LOGS,KAFKA_CERT,LOG_TIME_FORMAT,DEMO_LOGS_GENERIC):

    stream = os.popen('echo "'+KAFKA_CERT+'" > ./demouiapp/ca.crt')
    stream.read().strip()

    print ('    📛 KAFKA_BROKER  :'+str(KAFKA_BROKER)+':')

    try:

        conf = {'bootstrap.servers': KAFKA_BROKER,
                'security.protocol': "SASL_SSL",
                'sasl.mechanisms': 'SCRAM-SHA-512',
                'sasl.username': KAFKA_USER,
                'sasl.password': KAFKA_PWD,
                'client.id': socket.gethostname(),
                'enable.ssl.certificate.verification': 'false',
                'ssl.ca.location': './demouiapp/ca.crt'
                }

    #ssl.ca.location
        producer = Producer(conf)

        timestamp = datetime.datetime.now()
        print('Base timestamp:'+str(timestamp))

        timestamp = timestamp + datetime.timedelta(minutes=LOG_TIME_SKEW)

        for i in range (1,LOG_ITERATIONS):
            for line in DEMO_LOGS_GENERIC.split('\n'):
                timestamp = timestamp + datetime.timedelta(milliseconds=LOG_TIME_STEPS)      
                epoch = int(timestamp.timestamp())      
                timestampstr = timestamp.strftime(LOG_TIME_FORMAT)+'+00:00'
                epochstr = str(epoch)+'000'
                line = line.replace("MY_TIMESTAMP", timestampstr).strip()
                line = line.replace("MY_EPOCH", epochstr).strip()
                #print ('    XX:'+line)
                producer.produce(KAFKA_TOPIC_LOGS, value=line)

                    # stream = os.popen("oc get route  -n "+aimanagerns+" datalayer-api  -o jsonpath='{.status.ingress[0].host}'")
                    # print('     ❗ YOU MIGHT WANT TO USE THE DATALAYER PUBLIC ROUTE: '+str(stream.read().strip()))

            producer.flush()
            print('    📝 Logs-Injection: '+str(i)+'  :  '+str(timestamp))

    except KafkaException as e:
        print("aaaaaaERROR")
        print( "Kafka: "+str(e) )



    print ('✅ END - Inject Logs')

    return 'OK'



# ----------------------------------------------------------------------------------------------------------------------------------------------------
# INJECT EVENTS
# ----------------------------------------------------------------------------------------------------------------------------------------------------

def injectEventsMem(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD): 
    print ('📛 START - Inject Events - MEM ROBOTSHOP')
    injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,DEMO_EVENTS_MEM)
    return 'OK'


def injectEventsFanACME(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):  
    print ('📛 START - Inject Events - FAN ACME')
    injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,DEMO_EVENTS_FAN_ACME)
    return 'OK'


def injectEventsNetSock(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):  
    print ('📛 START - Inject Events - NET SOCKSHOP')
    injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,DEMO_EVENTS_NET_SOCK)
    return 'OK'


def injectEventsTube(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):  
    print ('📛 START - Inject Events - TUBE')
    injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,DEMO_EVENTS_TUBE)
    return 'OK'



def injectEventsTelco(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):  
    print ('📛 START - Inject Events - TELCO')
    injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,DEMO_EVENTS_TELCO)
    return 'OK'

def injectEventsBusy(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):  
    print ('📛 START - Inject Events - BUSY')
    injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,DEMO_EVENTS_BUSY)
    return 'OK'


def injectEventsCUSTOM(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD):  
    print ('📛 START - Inject Events - CUSTOM')
    injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,CUSTOM_EVENTS)
    return 'OK'


def injectEventsGeneric(DATALAYER_ROUTE,DATALAYER_USER,DATALAYER_PWD,DEMO_EVENTS):
    #print ('📛 START - Inject Events')
    #print ('📛 Inject Events'+str(DEMO_EVENTS))
    
    timestamp = datetime.datetime.now()
    #timestamp = str(datetime.datetime.now())
    #+%Y-%m-%dT%H:%M:%S

    url = 'https://'+DATALAYER_ROUTE+'/irdatalayer.aiops.io/active/v1/events'
    auth=HTTPBasicAuth(DATALAYER_USER, DATALAYER_PWD)
    headers = {'Content-Type': 'application/json', 'Accept-Charset': 'UTF-8', 'x-username' : 'admin', 'x-subscription-id' : 'cfd95b7e-3bc7-4006-a4a8-a73a79c71255'}


    for line in DEMO_EVENTS.split('\n'):
        timestamp = timestamp + datetime.timedelta(seconds=EVENTS_TIME_SKEW)
        timestampstr = timestamp.strftime("%Y-%m-%dT%H:%M:%S.000Z")

        line = line.replace("MY_TIMESTAMP", timestampstr)
        try:
            response = requests.post(url, data=line, headers=headers, auth=auth, verify=False)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            stream = os.popen("oc get route  -n "+aimanagerns+" datalayer-api  -o jsonpath='{.status.ingress[0].host}'")
            print('     ❗ YOU MIGHT WANT TO USE THE DATALAYER PUBLIC ROUTE: '+str(stream.read().strip()))
            raise SystemExit(e)

        print ('    🚀 Events-Injection:'+str(response.content))

    print ('✅ END - Inject Events')

    return 'OK'





# ----------------------------------------------------------------------------------------------------------------------------------------------------
# INJECT METRICS
# ----------------------------------------------------------------------------------------------------------------------------------------------------
# METRICS_TO_SIMULATE=[
# "mysql-predictive,MemoryUsagePercent,MemoryUsage,97,3",
# "mysql-predictive,MemoryUsageMean,MemoryUsage,50000,1000",
# "mysql-predictive,MemoryUsageMax,MemoryUsage,50000,10000",
# "mysql-predictive,PodRestarts,PodRestarts,ITERATIONS,1",
# "mysql-predictive,TransactionsPerSecond,TransactionsPerSecond,0,1",
# "mysql-predictive,Latency,Latency,1000,100",
# "ratings-predictive,MemoryUsagePercent,MemoryUsage,45,10",
# "ratings-predictive,MemoryUsageMean,MemoryUsage,50000,1000",
# "ratings-predictive,MemoryUsageMax,MemoryUsage,50000,10000",
# "ratings-predictive,PodRestarts,PodRestarts,0,1",
# "ratings-predictive,TransactionsPerSecond,TransactionsPerSecond,160,40",
# "ratings-predictive,Latency,Latency,2,1"
# ]

def injectMetricsMem(METRIC_ROUTE,METRIC_TOKEN): 
    print ('📛 START - Inject Metrics - MEM ROBOTSHOP')
    METRIC_TIME_SKEW=int(os.environ.get('METRIC_TIME_SKEW'))
    METRIC_TIME_STEP=int(os.environ.get('METRIC_TIME_STEP'))
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE_MEM,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsMem")
    return 'OK'

def injectMetricsFanTemp(METRIC_ROUTE,METRIC_TOKEN):  
    print ('📛 START - Inject Metrics - FAN-TEMP ROBOTSHOP')
    METRIC_TIME_SKEW=0
    METRIC_TIME_STEP=120
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE_FAN_TEMP,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsFanTemp")
    return 'OK'


def injectMetricsFan(METRIC_ROUTE,METRIC_TOKEN):  
    print ('📛 START - Inject Metrics - FAN ROBOTSHOP')
    METRIC_TIME_SKEW=int(os.environ.get('METRIC_TIME_SKEW'))
    METRIC_TIME_STEP=int(os.environ.get('METRIC_TIME_STEP'))
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE_FAN,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsFan")
    return 'OK'


def injectMetricsNet(METRIC_ROUTE,METRIC_TOKEN):  
    print ('📛 START - Inject Metrics - NET ROBOTSHOP')
    METRIC_TIME_SKEW=int(os.environ.get('METRIC_TIME_SKEW'))
    METRIC_TIME_STEP=int(os.environ.get('METRIC_TIME_STEP'))
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE_NET,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsNet")
    return 'OK'



def injectMetricsFanTempACME(METRIC_ROUTE,METRIC_TOKEN):  
    print ('📛 START - Inject Metrics - FAN-TEMP ACME')
    METRIC_TIME_SKEW=0
    METRIC_TIME_STEP=120
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE_FAN_TEMP_ACME,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsFanTempACME")
    return 'OK'


def injectMetricsFanACME(METRIC_ROUTE,METRIC_TOKEN):  
    print ('📛 START - Inject Metrics - FAN ACME')
    METRIC_TIME_SKEW=int(os.environ.get('METRIC_TIME_SKEW'))
    METRIC_TIME_STEP=int(os.environ.get('METRIC_TIME_STEP'))
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE_FAN_ACME,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsFanACME")
    return 'OK'


def injectMetricsSockNet(METRIC_ROUTE,METRIC_TOKEN):  
    print ('📛 START - Inject Metrics - NET SOCKSHOP')
    METRIC_TIME_SKEW=int(os.environ.get('METRIC_TIME_SKEW'))
    METRIC_TIME_STEP=int(os.environ.get('METRIC_TIME_STEP'))
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE_NET_SOCK,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsSockNet")
    return 'OK'


def injectMetricsCUSTOM(METRIC_ROUTE,METRIC_TOKEN):  
    print ('📛 START - Inject Metrics - CUSTOM METRICS')
    METRIC_TIME_SKEW=0
    METRIC_TIME_STEP=0
    injectMetrics(METRIC_ROUTE,METRIC_TOKEN,CUSTOM_METRICS,METRIC_TIME_SKEW,METRIC_TIME_STEP,"injectMetricsCUSTOM")
    return 'OK'




def injectMetrics(METRIC_ROUTE,METRIC_TOKEN,METRICS_TO_SIMULATE,METRIC_TIME_SKEW,METRIC_TIME_STEP,METRIC_NAME):
    #print ('📛 START - Inject Metrics')
    #print ('           METRIC_TIME_SKEW:               '+str(METRIC_TIME_SKEW))
    #print ('           METRIC_TIME_STEP:               '+str(METRIC_TIME_STEP))
    #print ('           METRICS_TO_SIMULATE:               '+str(METRICS_TO_SIMULATE))
    #print('     ❓ Getting IBMAIOps Namespace')
    stream = os.popen("oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}'")
    aimanagerns = stream.read().strip()
    #print('        ✅ IBMAIOps Namespace:       '+aimanagerns)


    print('     ❓ Getting Details Metric Endpoint')
    stream = os.popen("oc get route -n "+aimanagerns+"| grep ibm-nginx-svc | awk '{print $2}'")
    METRIC_ROUTE = stream.read().strip()
    METRIC_ROUTE=os.environ.get('METRIC_ROUTE_OVERRIDE', default=METRIC_ROUTE)

    stream = os.popen("oc get route -n "+aimanagerns+" cp-console  -o jsonpath={.spec.host}")
    CONSOLE_ROUTE = stream.read().strip()





    stream = os.popen("oc get secret -n "+aimanagerns+" platform-auth-idp-credentials -o jsonpath='{.data.admin_username}' | base64 --decode")
    tmpusr = stream.read().strip()
    print('     🟠 USR :'+str(tmpusr))

    stream = os.popen("oc get secret -n "+aimanagerns+" platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 --decode")
    tmppass = stream.read().strip()
    print('     🟠 PWD :'+str(tmppass))

    stream = os.popen('curl -s -k -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "grant_type=password&username='+tmpusr+'&password='+tmppass+'&scope=openid" https://'+CONSOLE_ROUTE+'/idprovider/v1/auth/identitytoken|jq -r \'.access_token\'')
    ACCESS_TOKEN = stream.read().strip()
    print('     🟠 ACCESS_TOKEN :'+ACCESS_TOKEN[:25]+'...')

    stream = os.popen('curl -s -k -XGET https://'+METRIC_ROUTE+'/v1/preauth/validateAuth -H "username: '+tmpusr+'" -H "iam-token: '+ACCESS_TOKEN+'"|jq -r ".accessToken"')
    METRIC_TOKEN = stream.read().strip()
    print('     🟠 METRIC_TOKEN :'+METRIC_ROUTE[:25]+'...')


    # #print('     ❓ METRICS_TO_SIMULATE' + str(METRICS_TO_SIMULATE))
    # stream = os.popen("oc get route -n "+aimanagerns+" | grep ibm-nginx-svc | awk '{print $2}'")
    # METRIC_ROUTE = stream.read().strip()
    # METRIC_ROUTE=os.environ.get('METRIC_ROUTE_OVERRIDE', default=METRIC_ROUTE)

    # stream = os.popen("oc get secret  -n "+aimanagerns+" admin-user-details -o jsonpath='{.data.initial_admin_password}' | base64 --decode")
    # tmppass = stream.read().strip()
    # stream = os.popen('curl -k -s -X POST https://'+METRIC_ROUTE+'/icp4d-api/v1/authorize -H "Content-Type: application/json" -d "{\\\"username\\\": \\\"admin\\\",\\\"password\\\": \\\"'+tmppass+'\\\"}" | jq .token | sed "s/\\\"//g"')
    # METRIC_TOKEN = stream.read().strip()

    requests.packages.urllib3.disable_warnings()

    timestamp = datetime.datetime.now()
    timestamp = timestamp + datetime.timedelta(seconds=METRIC_TIME_SKEW)

    CURR_ITERATIONS=0
    url = 'https://'+METRIC_ROUTE+'/aiops/api/app/metric-api/v1/metrics'

    headers = {'Content-Type': 'application/json', 'Accept-Charset': 'UTF-8', 'Authorization': 'Bearer '+METRIC_TOKEN, 'X-TenantID' : 'cfd95b7e-3bc7-4006-a4a8-a73a79c71255'}

    for i in range (1,METRIC_ITERATIONS):
        output_json='{"groups":['
        CURR_ITERATIONS=CURR_ITERATIONS+1

        for i in range (1,40):
            for line in METRICS_TO_SIMULATE:
                line=line.strip()
                #print('     ❓ elements' + str(line))
                timestamp = timestamp + datetime.timedelta(milliseconds=METRIC_TIME_STEP)
                MY_TIMESTAMP = timestamp.strftime("%s")
                MY_TIMESTAMP=MY_TIMESTAMP+"000"
                MY_TIMESTAMP_READABLE = timestamp.strftime("%Y-%m-%dT%H:%M:%S.000Z")
                #print (MY_TIMESTAMP)
                #print (MY_TIMESTAMP_READABLE)

                elements=line.split(',')
                #print('     ❓ line' + str(elements))

                MY_RESOURCE_NAME=elements[0]
                #print (MY_RESOURCE_NAME)
                MY_METRIC_NAME=elements[1]

                MY_GROUP_ID=elements[2]
                MY_FIX_VALUE=elements[3]
                MY_VARIATION=elements[4]

                if MY_FIX_VALUE == 'ITERATIONS':
                    CURRENT_VALUE=str(int(MY_VARIATION)+2*int(CURR_ITERATIONS))
                    #print ('ITER:'+str(CURRENT_VALUE))
                else:
                    CURRENT_VALUE = str(random.randint(int(MY_FIX_VALUE), int(MY_FIX_VALUE)+int(MY_VARIATION)))

                CURRENT_LINE='{"timestamp":"'+MY_TIMESTAMP+'","resourceID":"'+MY_RESOURCE_NAME+'","metrics":{"'+MY_METRIC_NAME+'":'+CURRENT_VALUE+'},"attributes":{"group":"'+MY_GROUP_ID+'","node":"'+MY_RESOURCE_NAME+'"} },'

                output_json=output_json+CURRENT_LINE


        LAST_LINE='{"timestamp":"'+MY_TIMESTAMP+'","resourceID":"'+MY_RESOURCE_NAME+'","metrics":{"'+MY_METRIC_NAME+'":'+CURRENT_VALUE+'},"attributes":{"group":"'+MY_GROUP_ID+'","node":"'+MY_RESOURCE_NAME+'"} }'
        output_json=output_json+LAST_LINE
        output_json=output_json+']}'
        #print (output_json)
        #print (MY_TIMESTAMP_READABLE)
        #print (MY_TIMESTAMP)

        try:
            response = requests.post(url, data=output_json, headers=headers, verify=False)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            stream = os.popen("oc get route -n "+aimanagerns+"| grep ibm-nginx-svc | awk '{print $2}'")
            print('     ❗ YOU MIGHT WANT TO USE THE METRIC PUBLIC ROUTE: '+str(stream.read().strip()))
            raise SystemExit(e)

        print ('    🚇 Metrics-Injection:'+str(METRIC_NAME)+' - '+str(MY_TIMESTAMP_READABLE)+' - '+str(response.content))
    print ('✅ END - Inject Metrics')

    return 'OK'



def checkTopology():
    print('🛠️ checkTopology')

    print('     ❓ Check if topology already exists')


    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology Application
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    cmdTopo = '''
    export APP_NAME="''' + CUSTOM_TOPOLOGY_APP_NAME + '''"
    export APP_NAME_ID=$(echo $APP_NAME| tr '[:upper:]' '[:lower:]'| tr ' ' '-')

    # echo $APP_NAME
    # echo $APP_NAME_ID


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)

    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    # echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    # echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D$APP_NAME_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dcustom-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo $APP_ID$TEMPLATE_ID

    '''
    
    stream = os.popen(cmdTopo)
    CHECK_APP = stream.read().strip()
    #print ('           APP_ID:              '+CHECK_APP)



    return CHECK_APP

def modifyProperty(RESOURCE_NAME,RESOURCE_TYPE,VALUES,):
    print('🛠️ modifyProperty')

    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Modify innodb_buffer_pool_size for Demo
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    print ('🟣           📈 DCUSTOM_PROPERTY_RESOURCE_NAME:    '+str(RESOURCE_NAME))
    print ('🟣           📈 DCUSTOM_PROPERTY_RESOURCE_TYPE:    '+str(RESOURCE_TYPE))
    print ('🟣           📈 DCUSTOM_PROPERTY_VALUES_NOK:       '+str(VALUES))

    
    cmdTopo = '''   
    echo "----------------------------------------------------------------------------------------------------------"
    echo "----------------------------------------------------------------------------------------------------------"
    echo "🚀 Modify ''' + RESOURCE_NAME + ''' for Demo"
    echo "----------------------------------------------------------------------------------------------------------"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export OBJ_ID=$(curl -k -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/resources?_filter=name%3D''' + RESOURCE_NAME + '''&_filter=entityTypes%3D''' + RESOURCE_TYPE + '''&_field=uniqueId&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=false" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo $OBJ_ID
    echo "    OBJ_ID: $OBJ_ID"

    export result=$(curl -k -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$OBJ_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d ' ''' + VALUES + ''' ')
    echo "    result: $result"
    '''

    print ('           cmdTopo:              '+cmdTopo)

     
    try:    
        stream = os.popen(cmdTopo)
        RES = stream.read().strip()
        print ('           modifyProperty DONE:              '+RES)
    except os.CalledProcessError as error:
        print ('           🟥 modifyProperty ERROR:              '+ str(error.output))



def modifyMYSQL():
    print('🛠️ modifyMYSQL')

    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Modify innodb_buffer_pool_size for Demo
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    cmdTopo = '''   
    echo "----------------------------------------------------------------------------------------------------------"
    echo "----------------------------------------------------------------------------------------------------------"
    echo "🚀 Modify innodb_buffer_pool_size for Demo"
    echo "----------------------------------------------------------------------------------------------------------"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export MYSQL_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/resources?_filter=name%3Dmysql&_filter=entityTypes%3Ddeployment&_field=uniqueId&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=false" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo $MYSQL_ID

    export result=$(curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$MYSQL_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{"innodb_buffer_pool_size": "1GB"}')
    echo $result
    '''
    
    print ('')
    print ('-------------------------------------------------------------------------------------------------')
    print ('   🚀 Modify innodb_buffer_pool_size for Demo')
    print ('-------------------------------------------------------------------------------------------------')
    stream = os.popen(cmdTopo)
    RES = stream.read().strip()
    print ('           DONE:              '+RES)



def resetMYSQL():
    print('🛠️ resetMYSQL')

    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Reset innodb_buffer_pool_size for Demo
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    cmdTopo = '''   
    echo "----------------------------------------------------------------------------------------------------------"
    echo "----------------------------------------------------------------------------------------------------------"
    echo "🚀 Reset innodb_buffer_pool_size for Demo"
    echo "----------------------------------------------------------------------------------------------------------"
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export MYSQL_ID=$(curl -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/resources?_filter=name%3Dmysql&_filter=entityTypes%3Ddeployment&_field=uniqueId&_include_global_resources=false&_include_count=false&_include_status=false&_include_status_severity=false&_include_metadata=false&_return_composites=false" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo $MYSQL_ID

    export result=$(curl -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/resources/$MYSQL_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d '{"innodb_buffer_pool_size": "8GB"}')
    echo $result
    '''
 
    print ('')
    print ('-------------------------------------------------------------------------------------------------')
    print ('   🚀 Reset innodb_buffer_pool_size for Demo')
    print ('-------------------------------------------------------------------------------------------------')
    stream = os.popen(cmdTopo)
    RES = stream.read().strip()
    print ('           DONE:              '+RES)






def loadTopology():
    print('🛠️ loadTopology')

    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    cmdTopo = '''                               
    echo \''''+str(CUSTOM_TOPOLOGY)+'''\'  > ./custom-topology.txt
    # echo ":::"
    # cat ./custom-topology.txt
    # echo ":::"

    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    # Get FILE_OBSERVER_POD
    FILE_OBSERVER_POD=$(oc get po -n $AIOPS_NAMESPACE -l app.kubernetes.io/instance=aiops-topology,app.kubernetes.io/name=file-observer -o jsonpath='{.items[0].metadata.name}')
    LOAD_FILE_NAME="custom-topology.txt"

    FILE_OBSERVER_CAP=$(pwd)"/custom-topology.txt"

    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"
    # echo "                     FILE_OBSERVER_POD:"$FILE_OBSERVER_POD
    # echo $FILE_OBSERVER_CAP
    # echo $TARGET_FILE_PATH
    echo "  Copying capture file to file observer pod"
    # echo "oc cp -n $AIOPS_NAMESPACE ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}"
    oc cp -n $AIOPS_NAMESPACE -c aiops-topology-file-observer ${FILE_OBSERVER_CAP} ${FILE_OBSERVER_POD}:${TARGET_FILE_PATH}
    '''

    #ALL_LOGINS = check_output(cmd, shell=True, executable='/bin/bash')

    

    if len(CUSTOM_TOPOLOGY)>0:
        print ('')
        print ('-------------------------------------------------------------------------------------------------')
        print ('   🚀 Custom Topology - FileObserver demoui-custom-topology')
        print ('-------------------------------------------------------------------------------------------------')
        print('     ❓ Upload Custom Topology - this may take a minute or two')
        stream = os.popen(cmdTopo)
        CREATE_TOPO = stream.read().strip()
        print ('           Upload Custom Topology:              '+CREATE_TOPO)

    else:
        print ('')
        print('     ❓ Skip Creating Custom Topology')
        print('     ❗ Has been disabled in the DemoUI configuration')




    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology File Observer
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    cmdTopo = '''
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    LOAD_FILE_NAME="custom-topology.txt"
    TARGET_FILE_PATH="/opt/ibm/netcool/asm/data/file-observer/${LOAD_FILE_NAME}"

    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
    export JOB_ID=demoui-custom-topology

    # echo "  URL: $TOPO_ROUTE"
    # echo "  LOGIN: $LOGIN"
    # echo "  TARGET_FILE_PATH: $TARGET_FILE_PATH"
    # echo "  JOB_ID: $JOB_ID"

    echo '{\"unique_id\": \"demoui-custom-topology\",\"description\": \"Automatically created by Nicks scripts\",\"parameters\": {\"file\": \"/opt/ibm/netcool/asm/data/file-observer/custom-topology.txt\"}}' > /tmp/custom-topology-observer.txt
        
    # Create FILE_OBSERVER JOB
    curl -X "POST" -s "$TOPO_ROUTE/1.0/file-observer/jobs" --insecure \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -H "accept: application/json" \
        -H "Content-Type: application/json"\
        -u $LOGIN \
        -d @/tmp/custom-topology-observer.txt
    '''

    if len(CUSTOM_TOPOLOGY)>0:
        print('     ❓ Creating Custom Topology File Observer - this may take a minute or two')
        stream = os.popen(cmdTopo)
        CREATE_TOPO = stream.read().strip()
        #print (''+CREATE_TOPO)






    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology Template
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    cmdTopo = '''
    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')

    # Get Credentials
    export TOPO_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPO_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)
    export LOGIN="$TOPO_REST_USR:$TOPO_REST_PWD"

    export TOPO_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-file-observer -o jsonpath={.spec.host})
    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export TEMPLATE_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dcustom-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)

    echo "    TEMPLATE_ID: $TEMPLATE_ID"

    if [ -z "$TEMPLATE_ID" ]
    then
        echo "  Create Template"
        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d '  {
            "keyIndexName": "custom-template",
            "_correlationEnabled": "true",
            "iconId": "application",
            "businessCriticality": "Gold",
            "vertexType": "group",
            "groupTokens": [
                "''' + CUSTOM_TOPOLOGY_TAG + '''"
            ],
            "correlatable": "true",
            "name": "custom-template",
            "entityTypes": [
                "completeGroup",
                "compute"
            ],
            "tags": [
                "demo"
            ]
        }'
    else
        echo "  Recreate Template"
        curl -s -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$TEMPLATE_ID" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'

        
        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d '  {
            "keyIndexName": "custom-template",
            "_correlationEnabled": "true",
            "iconId": "application",
            "businessCriticality": "Gold",
            "vertexType": "group",
            "groupTokens": [
                "''' + CUSTOM_TOPOLOGY_TAG + '''"
            ],
            "correlatable": "true",
            "name": "custom-template",
            "entityTypes": [
                "completeGroup",
                "compute"
            ],
            "tags": [
                "demo"
            ]
        }'
    fi


    '''

    if len(CUSTOM_TOPOLOGY_TAG)>0:
        print('     ❓ Creating Custom Topology Template - this may take a minute or two')
        stream = os.popen(cmdTopo)
        CREATE_TOPO = stream.read().strip()
        #print (''+CREATE_TOPO)







    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    # Creating Custom Topology Application
    # ----------------------------------------------------------------------------------------------------------------------------------------------------
    cmdTopo = '''
    echo "Create Custom Topology - Add Members to App"

    export APP_NAME="''' + CUSTOM_TOPOLOGY_APP_NAME + '''"
    export APP_NAME_ID=$(echo $APP_NAME| tr '[:upper:]' '[:lower:]'| tr ' ' '-')

    echo $APP_NAME
    echo $APP_NAME_ID


    export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    export TOPOLOGY_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.username}' | base64 --decode)
    export TOPOLOGY_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $AIOPS_NAMESPACE -o jsonpath='{.data.password}' | base64 --decode)

    export TOPO_MGT_ROUTE="https://"$(oc get route -n $AIOPS_NAMESPACE aiops-topology-topology -o jsonpath={.spec.host})

    export LOGIN="$TOPOLOGY_REST_USR:$TOPOLOGY_REST_PWD"

    echo "    URL: $TOPO_MGT_ROUTE/1.0/rest-observer/rest/resources"
    echo "    LOGIN: $LOGIN"

    export APP_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D$APP_NAME_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    export TEMPLATE_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3Dcustom-template" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo "    APP_ID:     "$APP_ID
    echo "    TEMPLATE_ID:"$TEMPLATE_ID
    echo "Create Custom Topology - Create App"

    echo '{\"keyIndexName\": \"'$APP_NAME_ID'\",\"_correlationEnabled\": \"true\",\"iconId\": \"cluster\",\"businessCriticality\": \"Platinum\",\"vertexType\": \"group\",\"correlatable\": \"true\",\"disruptionCostPerMin\": \"1000\",\"name\": \"'$APP_NAME'\",\"entityTypes\": [\"waiopsApplication\"],\"tags\": [\"app:'$APP_NAME_ID'\"]}' > /tmp/custom-topology-app.txt


    if [ -z "$APP_ID" ]
    then    
        echo "  Creating Application"
        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d @/tmp/custom-topology-app.txt
    else
        echo "  Application already exists"
        echo "  Re-Creating Application"
        curl -s -X "DELETE" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'


        curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups" --insecure \
        -u $LOGIN \
        -H 'Content-Type: application/json' \
        -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
        -d @/tmp/custom-topology-app.txt
    fi

    export APP_ID=$(curl -s -X "GET" "$TOPO_MGT_ROUTE/1.0/topology/groups?_field=*&_filter=keyIndexName%3D$APP_NAME_ID" --insecure -u $LOGIN -H 'Content-Type: application/json' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255'|jq -r -c '._items[]|._id'| tail -1)
    echo "    APP_ID:     "$APP_ID

    # # -------------------------------------------------------------------------------------------------------------------------------------------------
    # # CREATE EDGES
    # # -------------------------------------------------------------------------------------------------------------------------------------------------


    echo "  Add Template (File Observer) Resources"
    curl -s -X "POST" "$TOPO_MGT_ROUTE/1.0/topology/groups/$APP_ID/members" --insecure \
    -u $LOGIN \
    -H 'Content-Type: application/json' \
    -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' \
    -d '{
        \"_id\": \"'$TEMPLATE_ID'\"
    }'




    '''
    
    if len(CUSTOM_TOPOLOGY_APP_NAME)>0:
        print('     ❓ Creating Custom Topology Application - this may take a minute or two')
        stream = os.popen(cmdTopo)
        CREATE_TOPO = stream.read().strip()
        #print (''+CREATE_TOPO)
        print ('')
        print ('')
        print ('-------------------------------------------------------------------------------------------------')
        print ('   🚀 Get Parameters')
        print ('-------------------------------------------------------------------------------------------------')



    return 'OK'
