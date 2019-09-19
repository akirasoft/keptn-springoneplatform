**Building Autonomous Operations for Pivotal Cloud Foundry with Keptn** workshop given @[Spring One Platform 2019](https://springoneplatform.io/)

# Overview
In this workshop, you will get hands-on experience with the open source framework [keptn](https://keptn.sh) and see how it can help you to manage your cloud-native applications on Kubernetes.

1. For a great workshop experience, we ask you to keep track of your completed tasks. Therefore, please open this [spreadsheet](https://docs.google.com/spreadsheets/d/1D03FD_-yINTcGGzYcKH4_ES2t1skyZrV18O9mSyR3g0/edit?usp=sharing) and enter your name.

# Pre-requisites

## 1. Accounts

* **Dynatrace** - Create an account for a [trial Dynatrace SaaS tenant](https://www.dynatrace.com/trial) and create a PaaS and API token. See details in the [keptn docs](https://keptn.sh/docs/0.4.0/monitoring/dynatrace/).
* **GitHub** - A GitHub account is required and a personal access token with the permissions Keptn expects. See details in the [keptn docs](https://keptn.sh/docs/0.4.0/installation/setup-keptn/).
* **Cloud provider account** - If you will be unable to ssh to the bastion host from your machine, a GCP account is suggested to utilize Google Cloud Shell. It is recommedned to sign up for personal free trial to have full admin rights and to not cause any issues with your enterprise account. The below link can be used to sign up for a free trial:
   * [Google](https://cloud.google.com/free/)


## 2. GitHub Organization

Keptn expects all the code repositories and project files to be in the same GitHub organization.

* **GitHub Organization** -  You can create an organization using the instruction on [GitHub](https://github.com/organizations/new). 

    Suggested GitHub organization name: ```<your last name>-s1p-keptn```, e.g., ```mvilliger-s1p-keptn```

## 3. Tools

In this workshop, we are providing two options that will have all the required tools installed. Each attendee should have a piece of paper at their seat with a workshop number that will serve as your username and a temporary password usable only during the workshop.

* **Option A: Bastion host** - A bastion host has been provisioned on GCP with all necessary tools installed, home directories for every workshop attendee and pre-configured kubectl contexts to access each attendee's dedicated PKS cluster. 

```console
ssh suppliedusername@bastion.pks.gcp.aklabs.io
```

* **Option B: Docker in Google Cloud Shell** - For those that can't utilize a local ssh client connecting to the bastion host. a docker image has been created containing the same contents of the bastion host. This docker image can be executed via Google Cloud Shell.
1. For those that can't use an ssh client, just go to [Google Cloud](https://console.cloud.google.com) and activate Cloud Shell as shown below:
    <details><summary>Activate Cloud Shell</summary>
    <img src="images/cloud_shell.png" width="100%"/>
    </details>

1. To start the docker container you will use for this workshop, please execute:

    ```console
    docker run -d -t --name keptn-workshop mvilliger/keptn-workshop:0.3
    ```

1. Afterwards, you can shell into this container. Please execute:

    ```console
    docker exec -it keptn-workshop /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"
    ```

1. Finally, utilize the pks cli to fetch the necessary configuration context for kubectl:
    ```console
    pks login -k -a api.pks.gcp.aklabs.io -u <suppliedusername> -p <suppliedpassword>
    pks get-credentials <suppliedusername>
    ```  


# Install Keptn

1. Now, it's time to set up your workshop environment. During the setup, you will need the following values. We recommend copying the following lines into an editor, fill them out and keep them as a reference for later:

    ```
    Dynatrace Host Name (e.g. abc12345.live.dynatrace.com):
    Dynatrace API Token:
    Dynatrace PaaS Token:
    GitHub User Name:
    GitHub Personal Access Token:
    GitHub User Email:
    GitHub Organization:
    ```
1. Once you are logged onto the bastion host or shelled in to the container, navigate to the `scripts` folder:

    ```console
    cd scripts
    ```

1. Here you will find multiple scripts used for the setup and they must be run the right order.  Just run the setup script that will prompt you with menu choices.

    ```console
    ./setup.sh <deployment type>
    ```
    **Note**: While other options are available, for today's workshop, the only valid `deployment type` argument value is:
    * pks = Pivotal Container Service

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

This will prompt you for values that are referenced in the remaining setup scripts. Inputted values are stored in `creds.json` file. For example, the menu looks like:

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
```

## 3) Install Keptn

This will install the Keptn control plane components into your cluster, using the **Keptn CLI**: `keptn install -c=creds.json --platform=<Cluster>`

The install will take **5-10 minutes** to perform.

<details><summary>Details about this step</summary>

**Note**: Internally, this script will perform the following:
1. Clones https://github.com/keptn/installer.  This repo has the cred.sav templates for building a creds.json file that the Keptn CLI can use as an argument
1. Uses the values we already captured in the ```2-enterInstallationScriptInputs.sh``` script to create the creds.json file
1. Runs the ```keptn install -c=creds.json --platform=<Cluster>``` 

</details>

## 4) Install Dynatrace
This will install the Dynatrace OneAgent Operator into your cluster.

The install will take **3-5 minutes** to perform.

<details><summary>Details about this step</summary>

**Note**: Internally, this script will perform the following:
1. Clones https://github.com/keptn/dynatrace-service. This repo has scripts for each platform to install the Dyntrace OneAgent Operator and the cred_dt.sav template for building a creds_dt.json file that the install script expects to read
1. Uses the values we already captured in the ```1-enterInstallationScriptInputs.sh``` script to create the creds_dt.json file
1. Runs the ```/deploy/scripts/deployDynatraceOn<Platform>.sh``` script in the dynatrace-service folder

</details>

## 5) Expose Keptn's Bridge - OPTIONAL

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
