import requests
from requests.auth import HTTPBasicAuth
import json
import datetime
import random
import os
import time
from pathlib import Path

LOG_TIME_SKEW=0

timestamp =  datetime.datetime.now()

print ('✅ END - Inject Logs'+str(timestamp))

epoch = int(timestamp.timestamp())
# for windows:
# epoch = datetime.datetime(2021, 7,7 , 1,2,1).strftime('%S')
print(epoch)