<center> <h1>🐣 CloudPak for AIOps - Demo-in-a-Box</h1> </center>

<center> <h2>Custom Data Ingestion🚀</h2> </center>
<BR>
<center> ©2024 Niklaus Hirt / IBM </center>

 

<div style="page-break-after: always;"></div>

<BR>

### ⚠️ Disclaimer

<details>
<summary>Read...</summary>



> ### ❗ This is provided `as-is`:
> 
> * I'm sure there are errors
> * I'm sure it's not complete
> * It clearly can be improved
> 
> 
> Please contact me if you have feedback or if you find glitches or problems.
> 
> - on Slack: @niklaushirt or
> - by Mail: nikh@ch.ibm.com
> 
> 
> **❗The installation has been tested on OpenShift 4.14 and 4.15 on:**
> 
> - OpenShift Cluster (VMware on IBM Cloud) - UPI
> 
> But it should work on other Openshift Platforms as well (ROKS, Fyre, ...)
> 
> 
> 
> ❗ Those are **non-production** installations and are suited only for demo and PoC environments. 
> ❗ Please refer to the official IBM Documentation for production ready installations.

</details>

<div style="page-break-after: always;"></div>

---------------------------------------------------------------
# 0. Introduction
---------------------------------------------------------------

The idea of this repo is to provide an easy way to ingest demo data into an existing CP4AIOps cluster.



## 🚀 Getting Started

🐥 [Quick Install](#1-preparation)

* Get an OpenShift Cluster with AIOps installed
* Clone this repo
* Install prereqs
* Run the demo data ingestion scripts


🐥 [Ingest Demo Data](#2-data-ingestion)

<div style="page-break-after: always;"></div>


---------------------------------------------------------------
# 1. Preparation
---------------------------------------------------------------

<div style="page-break-after: always;"></div>

<details>
<summary>✅ Prerequisites</summary>

## 1.1 Prerequisites 

### OpenShift and CP4AIOps

You can either use an existing OpenShift cluster with CP4AIOps, OR deploy your own using the approach described via this overall git project.
The remainder of this readme assumes you have an existing OCP + AIOps cluster.

### 1.1.1 Install the 'oc' command line

1. Login to your OCP Cluster. 
2. Go to the question mark icon on the top right screen, select 'Command Line Tools'. 
3. Download and install oc - OpenShift Command Line Interface (CLI)
4. Login to your cluster via the "Copy login command" on the same screen where you downloaded the 'oc' command from

### 1.1.2 Install script dependencies

1. Ensure you have 'sed' and 'jq' installed. 

<div style="page-break-after: always;"></div>

</details>


---------------------------------------------------------------
# 2. Data Ingestion
---------------------------------------------------------------

<div style="page-break-after: always;"></div>

<details>
<summary>✅ Data Ingestion</summary>

### 2.1 Add the demo content

In `tools/97_addons/ibm-aiops-custom-scenarios/custom-tool/0_configuration.sh`, adjust the demo content for events and topology.


### 2.2 Run the scripts

1. Go to `tools/97_addons/ibm-aiops-custom-scenarios/custom-tool/`
2. Run `./1_customize-init.sh`
3. Run `./2_create-incident.sh` 


<div style="page-break-after: always;"></div>

</details>

