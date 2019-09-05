# Onboarding the carts service

Now that your environment is up and running and monitored by Dynatrace, you can proceed with onboarding the first application into your cluster. For this lab, we will use the carts application (a microservice), which emulates the behavior of a shopping cart and also comes with a (not very fancy) user interface. Besides, this service is written in Java Spring and uses a mongoDB database to store data.

To onboard the carts service, please follow these instructions:

1. Quit the setup script you were using to setup the infrastructure.

1. Navigate to the workshop directory:
    
    ```console
    cd /usr/keptn/keptn-hackfest2019
    ```

1. Go to https://github.com/keptn-sockshop/carts and click on the **Fork** button on the top right corner. Select the GitHub organization you use for this keptn workshop.

1. Clone the forked carts service to your running docker container. Please note that you have to use **your** own GitHub organization.

    ```console
    git clone https://github.com/your-github-org/carts.git
    ```
    
1. Change into the `keptn-onboarding` directory:

    ```console
    cd keptn-onboarding
    ```

1. Create the `sockshop` project, according to the provided *shipyard* file:

    ```console
    keptn create project sockshop shipyard.yaml
    ```

    This will create a configuration repository in your GitHub organization. This repository will contain a branch for each of the stages defined in the shipyard file in order to store the desired configuration of the application within that stage.

1. Since the `sockshop` project does not contain any services yet, it is time to onboard a service into the project. To onboard the `carts` service, execute the following command:

    ```console
    keptn onboard service --project=sockshop --values=values_carts.yaml
    ```

    To deploy the database, execute:

    ```console
    keptn onboard service --project=sockshop --values=values_carts_db.yaml --deployment=deployment_carts_db.yaml --service=service_carts_db.yaml
    ```

    Now, your configuration repository contains all the information needed to deploy your application and even supports blue/green deployments for two of the environments (staging and production).

---

:arrow_forward: [Next Lab: Deploying the carts service](../02_Deploying_the_carts_service)

:arrow_up_small: [Back to overview](https://github.com/johannes-b/keptn-hackfest2019#overview)