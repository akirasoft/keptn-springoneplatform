# Onboarding the carts service

Now that your environment is up and running and monitored by Dynatrace, you can proceed with onboarding the carts application into your cluster.
To do so, please follow these instructions:

1. Quit the setup script you were using to setup the infrastructure.
1. Navigate to the workshop directory:

  ```
  cd /usr/keptn/keptn-hackfest2019
  ```
1. Go to https://github.com/keptn-sockshop/carts and click on the **Fork** button on the top right corner.

  1. Select the GitHub organization you use for keptn.

  1. Clone the forked carts service to your local machine. Please note that you have to use your own GitHub organization.

  ```
  git clone https://github.com/your-github-org/carts.git
  ```


1. Change into the `keptn-onboarding` directory:

```
cd keptn-onboarding
```

1. Create the `sockshop` project:

```
keptn create project sockshop shipyard.yaml
```

This will create a configuration repository in your github repository. This repository will contain a branch for each of the stages defined in the shipyard file, in order to store the desired configuration of the application within that stage.

1. Since the `sockshop` project does not contain any services yet, it is time to onboard a service into the project. In this workshop, we will use a simple microservice that emulates the behavior of a shopping cart. This service is written in Java Spring and uses a mongoDB database to store data. To onboard the `carts` service, execute the following command:

```
keptn onboard service --project=sockshop --values=values_carts.yaml
```

To deploy the database, execute:

```
keptn onboard service --project=sockshop --values=values_carts_db.yaml --deployment=deployment_carts_db.yaml --service=service_carts_db.yaml
```

Now, your configuration repository contains all the information needed to deploy your application and even supports blue/green deployments for two of the environments (staging and production)!
