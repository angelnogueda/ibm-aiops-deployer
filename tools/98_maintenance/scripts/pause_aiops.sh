

#STOP
export PROJECT=cp4waiops
oc project $PROJECT
oc get statefulsets > ${PROJECT}_statefulsets.out
oc get deployments > ${PROJECT}_deployments.out
oc get deployments | awk '{print$1}' | while read eachpod; do oc scale deploy $eachpod --replicas=0; done
oc get statefulsets | awk '{print$1}' | while read eachpod; do oc scale sts $eachpod --replicas=0; done



exit 1

# RESTART
export PROJECT=cp4waiops
oc project $PROJECT
cat ${PROJECT}_statefulsets.out | grep -v NAME | grep "1/1" | awk '{print$1}' | while read eachone; do oc scale sts $eachone --replicas=1; done
cat ${PROJECT}_statefulsets.out | grep -v NAME | grep "2/2" | awk '{print$1}' | while read eachone; do oc scale sts $eachone --replicas=2; done
cat ${PROJECT}_statefulsets.out | grep -v NAME | grep "3/3" | awk '{print$1}' | while read eachone; do oc scale sts $eachone --replicas=3; done
cat ${PROJECT}_deploy.out | grep -v NAME | grep "1/1" | awk '{print$1}' | while read eachone; do oc scale deploy $eachone --replicas=4; done
cat ${PROJECT}_deploy.out | grep -v NAME | grep "2/2" | awk '{print$1}' | while read eachone; do oc scale deploy $eachone --replicas=5; done
cat ${PROJECT}_deploy.out | grep -v NAME | grep "3/3" | awk '{print$1}' | while read eachone; do oc scale deploy $eachone --replicas=6; done


