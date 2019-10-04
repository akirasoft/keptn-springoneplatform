# Onboarding the carts service

Now that your environment is up and running and monitored by Dynatrace, you can proceed with onboarding the first application into your cluster. For this lab, we will use the carts application (a microservice), which emulates the behavior of a shopping cart and also comes with a (not very fancy) user interface. Besides, this service is written in Java Spring and uses a mongoDB database to store data. If you are interested in the source code of the service, please [find it on Github](https://github.com/keptn-sockshop/carts).

## Create the project

To create a project which is the logical entity that holds services, please follow these instructions:


1. TODO In the docker container, quit the setup script you were using to setup the infrastructure.

1. Navigate to the `keptn-onboarding` folder in the workshop directory:
    
    ```console
    cd /usr/keptn/keptn-springoneplatform/keptn-onboarding
    ```

1. Create the `sockshop` project, according to the provided *shipyard* file:

    ```console
    keptn create project sockshop --shipyard=shipyard.yaml
    ```

    This will create a configuration repository in your cluster and version it with git. This repository will contain a branch for each of the stages defined in the shipyard file in order to store the desired configuration of the application within that stage.

## Onboard the service

1. Since the `sockshop` project does not contain any services yet, it is time to onboard a service into the project. To onboard the `carts` service, execute the following command:

    ```console
    keptn onboard service carts --project=sockshop --chart=./carts
    ```

1. After onboarding the service, we want to add a couple of test specifications as a basis for our quality gates. Therefore we add some additional resources to the service for the different stages.

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=dev --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    ```

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=staging --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    ```

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=dev --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
    ```

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=staging --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
    ```


1. Finally, a database is neded for the carts service to keep track of all items in the shopping cart:

    ```console
      keptn onboard service carts-db --project=sockshop --chart=./carts-db --deployment-strategy=direct
    ```

    Please note that we overwrite the deployment strategy for the database since we do not want a blue/green deployment in this case, but instead only a single instance per stage.

Now, your configuration repository contains all the information needed to deploy your application and even supports blue/green deployments for two of the environments (staging and production).

---

:arrow_forward: [Next Lab: Deploying the carts service](../02_Deploying_the_carts_service)
