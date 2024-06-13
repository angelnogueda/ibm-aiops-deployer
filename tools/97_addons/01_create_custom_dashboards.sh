# https://github.com/ibm/aiops-ui-extension-template

cd /tmp
git clone https://github.com/ibm/aiops-ui-extension-template
cd aiops-ui-extension-template

rm target.json

npm i

npm run enable -- -n ibm-aiops


nano target.json

demo
a180IoBxBSeM2RyFoFIdyb0nR8HLylcjdSo62174

npm start

npm run deploy -- -n  ibm-aiops

# npm run examples -- --remove -n ibm-aiops




{
  "url": "https://cpd-ibm-aiops.apps.656d9cdfeb178100111c14e8.cloud.techzone.ibm.com/",
  "username": "demo",
  "apiKey": "xxxxxxx",
  "tenantId": "cfd95b7e-3bc7-4006-a4a8-a73a79c71255",
  "bundleName": "alerts-examples"
}




/login?token=P4ssw0rd%21

https://ibm-aiops-demo-ui-ibm-aiops-demo-ui.apps.65702ecd6595ac00115a66e9.cloud.techzone.ibm.com/injectAllTUBEREST





