<img src="images/keptn.png" width="100%"/>

**Building unbreakable automated multi-stage pipelines with keptn** workshop given @[Lakeside Hackfest 2019](https://www.lakeside-hackfest.com/)

# Overview
In this workshop, you will get hands-on experience with the open source framework [keptn](https://keptn.sh) and see how it can help you to manage your cloud-native applications on Kubernetes.

1. For a great workshop experience, we ask you to keep track of your completed tasks. Therefore, please open this [spreadsheet](https://docs.google.com/spreadsheets/d/1D03FD_-yINTcGGzYcKH4_ES2t1skyZrV18O9mSyR3g0/edit?usp=sharing) and enter your name.

# Pre-requisites

## 1. Accounts

* **Dynatrace** - Create an account for a [trial Dynatrace SaaS tenant](https://www.dynatrace.com/trial) and created a PaaS and API token. See details in the [keptn docs](https://keptn.sh/docs/0.4.0/monitoring/dynatrace/).
* **GitHub** - A GitHub account is required and a personal access token with the permissions Keptn expects. See details in the [keptn docs](https://keptn.sh/docs/0.4.0/installation/setup-keptn-gke/).
* **Cloud provider account** - Highly recommend to sign up for personal free trial to have full admin rights and to not cause any issues with your enterprise account. Links to free trials:
   * [Google](https://cloud.google.com/free/)
   * [Azure](https://azure.microsoft.com/en-us/free/)

## 2. GitHub Organization

Keptn expects all the code repositories and project files to be in the same GitHub organization.

* **GitHub Organization** -  You can create an organization using the instruction on [GitHub](https://github.com/organizations/new). 

    Suggested GitHub organization name: ```<your last name>-keptn-hackfest-<cloud provider>```, e.g., ```braeuer-keptn-hackfest-gcloud```

## 3. Tools

In this workshop, we are going to use a pre-built Docker image that already has all required tools installed. The only requirement is that you have Docker installed on your machine, or you can use the Google Cloud Shell if you have a Google account.  

* **Option A: Docker local** - You can install Docker using the instructions on the [Docker homepage](https://docs.docker.com/install/).

* **Option B: Docker in Google Cloud Shell** - Just go to [Google Cloud](https://console.cloud.google.com) and activate Cloud Shell as shown below:
    <details><summary>Activate Cloud Shell</summary>
    <img src="images/cloud_shell.png" width="100%"/>
    </details>

# Provision Cluster and Install Keptn

1. Now, it's time to set up your workshop environment. During the setup, you will need the following values. We recommend copying the following lines into an editor, fill them out and keep them as a reference for later:

    ```
    Dynatrace Host Name (e.g. abc12345.live.dynatrace.com):
    Dynatrace API Token:
    Dynatrace PaaS Token:
    GitHub User Name:
    GitHub Personal Access Token:
    GitHub User Email:
    GitHub Organization:
    PaaS Resource Prefix (e.g. lastname): 
    ======== Azure only =========
    Azure Subscription ID:
    Azure Location: francecentral
    ======== GKE only ===========
    Google Project:
    Google Cluster Zone: us-east1-b
    Google Cluster Region: us-east1
    ```

    **Note:** The **Azure Subscription ID** can be found in your [Azure console](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade):
    <details><summary>Show screenshot</summary>
    <img src="images/azure_subscription.png" width="100%"/>
    </details>

    **Note:** The **Google Project** can be found at the top bar of your [GCP console](https://console.cloud.google.com):
    <details><summary>Show screenshot</summary>
    <img src="images/gcloud_project.png" width="100%"/>
    </details>

1. To start the docker container you will use for this workshop, please execute:

    ```console
    docker run -d -t jbraeuer/keptn-demo
    ```

1. Afterwards, you can SSH into this container. First, retrieve the `CONTAINER_ID` of the `keptn-demo` container. Then, use that ID to SSH into the container:

    ```console
    docker ps
    ```

    ```console
    docker exec -it <CONTAINER_ID> /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"
    ```

1. When you are in the container, you need to log in to your PaaS account (GCP or AKS):

    - If you are using **GCP**, execute `gcloud init`
    - If you are using **Azure**, execute `az login`

1. When you are logged in you PaaS account, navigate to the `scripts` folder:

    ```console
    cd scripts
    ```

1. Here you will find multiple scripts used for the setup and they must be run the right order.  Just run the setup script that will prompt you with menu choices.

    ```console
    ./setup.sh <deployment type>
    ```
    **Note**: Valid `deployment type` argument values are:
    * gke = Google
    * aks = Azure

    The setup menu looks as follows:
    ```
    ====================================================
    SETUP MENU for Azure AKS
    ====================================================
    1)  Enter Installation Script Inputs
    2)  Provision Kubernetes cluster
    3)  Install Keptn
    4)  Install Dynatrace
    5)  Expose Keptn's Bridge
    ----------------------------------------------------
    99) Delete Kubernetes cluster
    ====================================================
    Please enter your choice or <q> or <return> to exit
    ```

## 1) Enter Installation Script Inputs

Before you do this step, be prepared with your GitHub credentials, Dynatrace tokens, and Cloud provider project information available.

This will prompt you for values that are referenced in the remaining setup scripts. Inputted values are stored in `creds.json` file. For example, on GKE the menus looks like:

```
===================================================================
Please enter the values for provider type: Google GKE:
===================================================================
Dynatrace Host Name (e.g. abc12345.live.dynatrace.com)  (current: DYNATRACE_HOSTNAME_PLACEHOLDER) : 
Dynatrace API Token                                     (current: DYNATRACE_API_TOKEN_PLACEHOLDER) : 
Dynatrace PaaS Token                                    (current: DYNATRACE_PAAS_TOKEN_PLACEHOLDER) : 
GitHub User Name                                        (current: GITHUB_USER_NAME_PLACEHOLDER) : 
GitHub Personal Access Token                            (current: PERSONAL_ACCESS_TOKEN_PLACEHOLDER) : 
GitHub User Email                                       (current: GITHUB_USER_EMAIL_PLACEHOLDER) : 
GitHub Organization                                     (current: GITHUB_ORG_PLACEHOLDER) : 
PaaS Resource Prefix (e.g. lastname)                    (current: RESOURCE_PREFIX_PLACEHOLDER) :
Google Project                                          (current: GKE_PROJECT_PLACEHOLDER) : 
Cluster Name                                            (current: CLUSTER_NAME_PLACEHOLDER) : 
Cluster Zone (eg.us-east1-b)                            (current: CLUSTER_ZONE_PLACEHOLDER) : 
Cluster Region (eg.us-east1)                            (current: CLUSTER_REGION_PLACEHOLDER) :
```

## 2) Provision Kubernetes Cluster

This will provision a cluster on the specified cloud deployment type using the platforms CLI. This script will take several minutes to run and you can verify the cluster was created with the the cloud provider console.

The cluster will take **5-10 minutes** to provision.

## 3) Install Keptn

This will install the Keptn control plane components into your cluster, using the **Keptn CLI**: `keptn install -c=creds.json --platform=<Cluster>` 

The install will take **5-10 minutes** to perform.

<details><summary>Details about this step</summary>

**Note**: Internally, this script will perform the following:
1. Clone https://github.com/keptn/installer.  This repo has the cred.sav templates for building a creds.json file that the Keptn CLI can use as an argument
1. Use the values we already captured in the ```2-enterInstallationScriptInputs.sh``` script to create the creds.json file
1. Run the ```keptn install -c=creds.json --platform=<Cluster>``` 
1. Run the `Show Keptn` helper script

</details>

## 4) Install Dynatrace
This will install the Dynatrace OneAgent Operator into your cluster.

The install will take **3-5 minutes** to perform.

<details><summary>Details about this step</summary>

**Note**: Internally, this script will perform the following:
1. Clone https://github.com/keptn/dynatrace-service. This repo has scripts for each platform to install the Dyntrace OneAgent Operator and the cred_dt.sav template for building a creds_dt.json file that the install script expects to read
1. Use the values we already captured in the ```1-enterInstallationScriptInputs.sh``` script to create the creds_dt.json file
1. Run the ```/deploy/scripts/deployDynatraceOn<Platform>.sh``` script in the dynatrace-service folder
1. Run the `Show Dynatrace` helper script

</details>

## 5) Expose Keptn's Bridge

The [Keptn’s bridge](https://keptn.sh/docs/0.4.0/reference/keptnsbridge/) provides an easy way to browse all events that are sent within Keptn and to filter on a specific Keptn context. When you access the keptn’s bridge, all Keptn entry points will be listed in the left column. Please note that this list only represents the start of a deployment of a new artifact. Thus, more information on the executed steps can be revealed when you click on one event.

<img src="images/bridge-empty.png" width="500"/>

In the default installation of Keptn, the bridge is only accessible via `kubectl port-forward`. To make things easier for workshop participants, we will expose it by creating a public URL for this component.

# Hands-on Labs

After provision the cluster and installing Keptn, we are now ready to explore to execute the following hands-on labs. They are based on each other, why it is important to complete the according to this order:

1. Onboarding the carts service: [Lab](./01_Onboarding_carts_service)
1. Deploying the carts service: [Lab](./02_Deploying_the_carts_service)
1. Introducing quality gates: [Lab](./03_Introducing_quality_gates)
1. **Homework ;)** Runbook automation and self-healing: [Lab](./04_Runbook_Automation_and_Self_Healing)

# Keptn Community

Join the Keptn community!

Further information about Keptn you can find on the [keptn.sh](keptn.sh) website. Keptn itself lives on [GitHub](https://github.com/keptn/keptn).

**Feel free to contribute or reach out to the Keptn team using a channel provided [here](https://github.com/keptn/community)**.