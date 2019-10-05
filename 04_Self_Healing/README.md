# Self Healing with Keptn

## About this use case

In this use case you will learn how to use the capabilities of Keptn to provide self-healing for an application without modifying any of the applications code. The use case presented in the following will scale up the pods of an application if the application undergoes heavy CPU saturation.

## Prerequisites
A couple of specifications files are needed for Keptn to actually know which remediation to perofrm and to verify if the executed remediation was successful.
These files have already put in your Docker container.

## Configure keptn

In order for keptn to utilize Prometheus metrics to support self-healing, the configured Service Indicators, Service Objectives and Remediation steps need to be updated. 

1. Add the needed resources to enable self-healing in your production environment:

    ```console
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=service-indicators.yaml --resourceUri=service-indicators.yaml
    ```
    ```console
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=service-objectives-prometheus-only.yaml --resourceUri=service-objectives.yaml
    ```
    ```console
    keptn add-resource --project=sockshop --service=carts --stage=production --resource=remediation.yaml --resourceUri=remediation.yaml
    ```

    <details><summary>Learn more about those files here</summary>

    - **service-indicators.yaml:** The `service-indicators.yaml` file specifies the indicators that can be used to describe service objectives. These indicators are metrics gathered from monitoring sources and they are defined by a query. The query to obtain the metric is source-specific.

    - **service-objectives.yaml:** The `service-objectives.yaml` file specifies the service level objectives for one or more services. Therefore, this file first defines thresholds that express the fullfillment of the objectives by the pass and warning property. An evaluated objective that achives a score above the pass limit is considered to be fullfilled, between warning and pass it is in an acceptable range, and below warning it is not fullfilled. The objectives property lists all service level indicators by their metric name that are considered for this objective. Besides, each indicator is augmented by a threshold and timeframe. While the threshold defines the acceptance criteria of this indicator, the timeframe indicates the duration in which the metrics is evaluated. Finally, the score specifies the max number of points that can be achieved by this indicator.

    - **remediation.yaml:** The remediation.yaml file defines remediation actions to execute in response to a problem related to the defined problem pattern / service objective. This action is interpreted by Keptn to trigger the proper remediation.

    </details>

2. Configure Prometheus with the Keptn CLI

    ```console
    keptn configure monitoring prometheus --project=sockshop --service=carts
    ``` 

    This will set up Prometheus as the monitoring solution used in this use case (please note that with Keptn 0.5.0 Dynatrace is not yet supported for this use case). In addition, Keptn configures Prometheus monitoring as well as the Prometheus Alert Manager to send out alerts in case of high CPU saturation.

## Run the use case

### Deploy and unhealthy version of the carts service

Tests can never capture all issues a service might undergo in a production environment. As we will see, our _carts_ microservice is already running in our production environment hence it will cause some issues. This is due to the fact that real-user traffic is different than synthetic test traffic and we might not be able to test all real-user actions in our test phase.

### Generate load for the service

In order to simulate user traffic that is causing an unhealthy behavior in the carts service, please execute the following script. This will add special items into the shopping cart that cause some extensive calculation.

1. Move to the correct folder:

    ```console
    cd /usr/keptn/examples/load-generation/bin
    ```

1. Execute the load generation program:
    ```console
    ./loadgenerator-linux "http://carts.sockshop-production.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')" cpu
    ```
    This will constantly add items in the shopping cart and cause some CPU heavy calculations since due to the characteristics of the added items.


### Watch self-healing in action

After approximately 15 minutes, the Prometheus Alert Manager will send out an alert since the service level objective is not met anymore.

1. We can verify if Keptn is triggering and upscale of the affected deployment by executing:
    ```console
    kubectl get deployments -n sockshop-production
    ```

    We can see that the `carts-primary` deployment is now served by two pods.
    ```console
    NAME             DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    carts-db         1         1         1            1           37m
    carts-primary    2         2         2            2           32m
    ```

2. In Prometheus, we can also verify the load and the triggered remediation action.

    First we need a port-forward to access the internal Prometheus installation:
    ```console
    kubectl port-forward svc/prometheus-service -n monitoring 8080:8080
    ```
    Now access Prometheus from your browser on http://localhost:8080

    In the graph tab, add the following expression:
    ```console
    avg(rate(container_cpu_usage_seconds_total{namespace="sockshop-production",pod_name=~"carts-primary-.*"}[5m]))
    ```
    Select the graph tab to see your CPU metrics of the carts-primary pods in the sockshop-production environment and you should see something similar:

    <img src="images/prometheus-load.png" width="70%"/>

    After a couple of minutes we should able to see that the CPU usage is decreasing due to the scale up of the pods.
    
    <img src="images/prometheus-load-reduced.png" width="70%"/>

3. Verify self-healing in the Keptn's bridge.

    In this example, the bridge shows that the remediation service triggered an update of the configuration of the carts service by increasing the number of replicas to 2. When the additional replica was available, the wait-service waited for three minutes for the remediation action to take effect. Afterwards, an evaluation by the pitometer-service was triggered to check if the remediation action resolved the problem. In this case, increasing the number of replicas achieved the desired effect, since the evaluation of the service level objectives has been successful.

    <img src="images/bridge_remediation.png" width="100%"/>


---

[Previous Step: Introducing quality gates](../03_Introducing_quality_gates) :arrow_backward: :arrow_forward:

