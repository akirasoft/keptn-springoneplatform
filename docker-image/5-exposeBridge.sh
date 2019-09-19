#!/bin/bash
DEPLOYMENT=$1
if [[ $DEPLOYMENT == "pks" ]]; then
  echo ""
  echo "Bridge is not supported on Pivotal Container Service"
  exit 1
fi

DOMAIN=$(kubectl get cm -n keptn keptn-domain -oyaml | yq - r data.app_domain)

rm -f ./manifests/gen/bridge.yaml
cat ./manifests/bridge.yaml | \
  sed 's~DOMAIN_PLACEHOLDER~'"$DOMAIN"'~' > ./manifests/gen/bridge.yaml

kubectl apply -f ./manifests/gen/bridge.yaml

echo "Bridge URL: https://bridge.keptn.$DOMAIN"
