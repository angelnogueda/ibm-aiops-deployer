# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [46.0.1] - 2024-06-05
### Major changes
- Support for Version 4.6.0 FVT




## [45.0.2] - 2023-04-12
### Minor changes
- RobotShop Scenatio now creates change in the mysql Topology resource to show Delta 
- Custom View for Alerts with Links
- LogAnomaly Golden Signals (LAGS) working pretty reliably for RobotShop
- A lot of work on reliable installation
- Instana installation works more reliably (still now a 100%)
- Uninstall Script now works reliably for reinstall afterwards


## [45.0.1] - 2023-02-01
### Major changes
- Support for Version 4.5.0 GA
- Suppression of Log Anomaly RSA and NLP
- New LogAnomaly Golden Signals (LAGS) Scenarios
- Hack for bug in topology for loading customization



## [44.0.6] - 2023-02-27
### Major changes
- DemoUI now supports custom scenarios



## [44.0.5] - 2023-02-22
### Minor changes
- OCP-OpenLDAP Integration (added parameter integrate_ocp_openldap)
- Various fixes for non standard Namespace install (thanks Mario Schuerewegen)



## [44.0.4] - 2023-02-21
### Minor changes
- Fixed Installer permissions Service Account (thanks Mario Schuerewegen)




## [44.0.3] - 2023-02-19
### Minor changes
- Scenario for telco Scenario - Optical Fiber Cut (thanks Zane!)
- Minor bug fixes



## [44.0.2] - 2023-02-01
### Major changes
- Support for Version 4.4.0 GA
- Suppression of ibm-common-services Namespace
- Installation of Prerequisites
    - IBM Lincensing
    - Cert Manager



## [44.0.1] - 2023-01-22
### Major changes
- Support for Version 4.4.0 RC1
- Suppression of ibm-common-services Namespace
- Installation of Prerequisites
    - IBM Lincensing
    - Cert Manager



## [43.0.2] - 2023-12-07
### Minor changes
- Added Runbooks for Incident Creation
- Added AIOps Dashboard Card for Incident Creation
- Overhaul of DemoUI



## [43.0.1] - 2023-12-06
### Major changes
- Support for Version 4.3.0

### Fixes
- New format for Policies



## [42.0.3] - 2023-10-13
### Minor changes
- Added Pre-Canned Event Data for out-of-the-box Temporal training



## [42.0.2] - 2023-10-10
### Minor changes
- DemUI Overhaul, now allows to link with static SNOW and Slack Incidents
- New Flag create_valid_ingress_itz to patch ingress certificates when on ITZ UPI/IPI (specifically for Wlodek)




## [42.0.1] - 2023-10-02
### Minor changes
- Adaptations for Version 4.2.0



  
## [41.2.1] - 2023-09-13
### Minor changes
- Turbo 8.10.0
- Instana 255.0
- Log Anomalies for SockShop and ACME

### Fixes
- Bugfix for installation into other namespace (not ibm-aiops) - Thanks Mario Schuerewegen
- AWX Operator bug




## [41.1.1] - 2023-08-23
### Minor changes
- Adaptations for Version 4.1.1
- Check Installation at the end
- General robustness of install scripts



## [41.0.1] - 2023-07-03
### Major changes
- Version 4.1.0
- Deprecation of EventManager
- Deprecation of AIManager Name
- Complete overhaul of file structure
- Complete overhaul of naming conventions (AIManager-->IBMAIOPS)



## [37.1.2] - 2023-05-25
### Major changes
- Rename CP4WAIOPS to IBM AIOps



## [37.1.1] - 2023-05-04
### Major changes
- Prepare for deprecation of EventManager
- Prepare for deprecation of AIManager Name
- Complete overhaul of file structure
- Complete overhaul of naming conventions (AIManager-->IBMAIOPS)
- OCP Console Notifications for Installation Progress


## [37.0.1] - 2023-04-14
### Major changes
- Added SockShop and ACME Air




## [37.0.1] - 2023-03-31
### Minor changes
- Probes (generic and Turbonomic)
- Ingress credentials for ITZ IPI (Thanks to Włodzimierz Dymaczewski)




## [37.0.0] - 2023-03-29
Release for 3.7.0 GA

### Major changes
- Support for IBMAIOPS 3.7.0
- Support for Instana Datastores CRD

### Minor changes
- New RobotShop Overlay Topology





## [36.0.1] - 2022-01-20
### Minor changes
- WebHook Probe Added



## [36.0.1] - 2022-01-16
### Fixes
- A lot of small bugfixes

### Minor changes
- Added EDA (Event Driven Ansible) Demo scripts for Turbo
- Added custom, non-official Discord integrations 





## [36.0.2] - 2022-12-21
Changes for Cloud Pak Deployer compatibility




## [36.0.1] - 2022-12-20
### Fixes
- Fix for Event Manager Version

### Minor changes
- Added encrypted Instana and Trubonomic licenses





## [36.0.0] - 2022-12-14
Release for 3.6.0 GA

### Major changes
- Support for IBMAIOPS 3.6.0

### Minor changes
- Added Business Criticalities
- Option to freeze the Catalog version





## [35.1.6] - 2022-12-06
### Fixes
- Fixed patching for valid ingress certificates




## [35.1.5] - 2022-11-17
### Major changes
- Added IBMAIOps Cards
- Added Turbonomic Demo Content




## [35.1.4] - 2022-11-15
### Major changes
- Added Instana to the mix (mostly stolen from Luca Floris - thanks!!!)




## [35.1.3] - 2022-11-11
### Major changes
- A lot of consolidation for integration into https://github.com/IBM/cloud-pak-deployer



## [35.1.2] - 2022-10-27
### Major changes
- Corrected a bug with links in the Demo UI 
- Secured routes for RobotShop, LDAP, Spark



## [35.1.1] - 2022-10-26
### Major changes
- Compatible with 3.5.1
- Added possibility to use custom sizing configurations



## [35.0.5] - 2022-10-23
### Major changes
- Update to DemoUI - new Interface design to match Techzone



## [35.0.5] - 2022-10-21
### Major changes
- Update to DemoUI - separate Namespace
- Corrected blocking installation for DemoUI



## [35.0.4] - 2022-10-12
### Major changes
- OpenLDAP with persistence - thanks Włodzimierz Dymaczewski



## [35.0.3] - 2022-09-30
### Major changes
- Added scripts to check installation



## [35.0.2] - 2022-09-28
Release for 3.5.0 GA

### Major changes
- Support for IBMAIOPS 3.5.0




## [35.0.1] - 2022-09-08
Release for 3.5.0 FVT on OCP VPC 2

### Major changes
- Support for OCS/ODF
- New AWX Version 
- Corrected AWX execution bug




## [35.0.0] - 2022-08-29
Release for 3.5.0 FVT 

### Major changes
- Support for disruptionCostPerMin
- Adapted LAD model






## [34.1.0] - 2022-06-29
Release for 3.4.1 GA. 

### Major changes
- Support for version AIOPS 3.4.1
- Re-added fixed ChangeRisk training






## [34.0.2] - 2022-06-29
Release for 3.4.0 GA. 
Some specifics apply: please see the README file.

### Major changes
- Support for version AIOPS 3.4
- Completely revamped the Ansible project structure

### Changed features
- All steps for demo content are now automated



## [34.0.1] - 2022-06-14
Complete rewrite for future integration into CloudPak Deployer.
The installation is now based on configuration files containing the features to be installed.
For a complete example see ./ansible/configs/ibm-aiops-roks-all-33.yaml 

### Major changes
- New file structure



## [34.0.0] - 2022-06-09
Release for Field Validation Testing. 
Some specifics apply: please see the README file.
### Major changes
- Support for version AIOPS 3.4
- All steps can be executed sequentially as connections are getting created by the script

### Changed features
- Updated AWX based install

### Fixes
- Fix for training not running through
- Fix for Turbonomic install