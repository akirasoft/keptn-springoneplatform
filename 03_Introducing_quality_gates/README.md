# Introducing quality gates

Since you have already set up your cluster to be monitored by Dynatrace, keptn can use its information to evaluate performance tests and to decide wether an artifact should be promoted, based on quality gates. Quality gates allow you to define limits for certain metrics (such as the response time of a service) that must not be exceeded by a service. If these criteria are met, an artifact will be allowed to proceed to the nest stage, otherwise the deployment will be rolled back automatically. You can specify quality gates in a file called `perfspec/perfspec.json` within the code repository of the respective service (`carts` in our case).
After forking the `carts` repository into your organization, the `perfspec` directory within that repository contains two files:

  - `perfspec_dynatrace.json`
  - `perfspec_prometheus.json`

In this workshop we will be using Dynatrace to retrieve metrics. Thus, to enable the Dynatrace quality gates, please rename `perfspec_dynatrace.json` to `perfspec.json`, and commit/push your changes to the repository. To do so, either execute the following commands on your machine, or rename the file directly within the GitHub UI.

```
cd ~/respositories/carts
mv perfspec_dynatrace.json perfspec.json
git add .
git commit -m "enabled quality gates using dynatrace"
git push
```

Now your carts service will only be promoted into production if it adheres to the quality gates (response time < 1s) specified in the `perfspec.json` file.

## Deployment of a slow implementation of the carts service

To demonstrate the benefits of having quality gates, we will now deploy a version of the carts service with a terribly slow response time. To trigger the deployment of this version, please execute the following command on your machine:

```
keptn send event new-artifact --project=sockshop --service=carts --image=docker.io/keptnexamples/carts --tag=0.8.2
```

After some time, this new version will be deployed into the `dev` stage. If you look into the `shipyard.yaml` file that you used to create the `sockshop` project, you will see that in this stage, only functional tests are executed. This means that even though version has a slow response time, it will be promoted into the `staging` environment, because it is working as expected on a functional level. You can verify the deployment of the new version into `staging` by navigating to the URL of the service in your browser using the following URL:

```
echo http://carts.sockshop-staging.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
```

On the info homepage of the service, the **Version** should now be set to **v2**, and the **Delay in ms** value should be set to **1000**. (Note that it can take a few minutes until this version is deployed after sending the `new-artifact` event.)

As soon as this version has been deployed into the `staging` environment, the `jmeter-service` will execute the performance tests for this service. When those are finished, the `pitometer-service` will evaluate them using Dynatrace as a data source. At this point, it will detect that the response time of the service is too high and mark the evaluation of the performance tests as `failed`.

As a result, the new artifact will not be promoted into the `production` stage. Additionally, the traffic routing within the `staging` stage will be automatically updated in order to send requests to the previous version of the service. You can again verify that by navigating to the service homepage and inspecting the **Version** property. This should now be set to **v1** again.
