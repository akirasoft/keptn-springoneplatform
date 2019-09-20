#!/bin/bash
KEPTN_ENDPOINT=https://control.keptn.$(kubectl get cm -n keptn keptn-domain -oyaml | yq - r data.app_domain)
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -o=yaml | yq - r data.keptn-api-token | base64 --decode)

echo "keptn endpoint: $KEPTN_ENDPOINT"
echo "keptn api-token: $KEPTN_API_TOKEN"

keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN