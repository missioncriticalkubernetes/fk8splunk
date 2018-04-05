# fk8splunk

> Use [fluentd](https://github.com/fluent/fluentd) to send [kubernetes](https://github.com/kubernetes/kubernetes) logs to [splunk](https://github.com/splunk)

# Credits

Original can be found [here](https://github.com/ziyasal/k8splunk)

# Requirements

* Splunk HTTP Event Collector (HEC)-address
* HEC-token
* Kubernetes cluster and write access to the `kube-system`-namespace
* When using `PodSecurityPolicy`s, make sure you grant the `fk8splunk` service-account access to use `hostPath` volume-mounts.

# Installation

## Fluentd log forwarder
```
# export our Splunk HEC token (use your own)
export SPLUNKHEC_OPTION_token="C2CE8936-73B5-4BBA-9EE2-312A70279AD3"

# Or generate a UUID to act as Splunk HEC token if you're using the Splunk forwarder below
# For example, on MacOSX:
export SPLUNKHEC_OPTION_token=$(uuidgen)

# Create a secret to hold your Splunk configuration
kubectl -n logging create secret generic fk8splunk --from-literal=SPLUNKHEC_OPTION_host=splunk.logging --from-literal=SPLUNKHEC_OPTION_port=8088 --from-literal=SPLUNKHEC_OPTION_index=main --from-literal=SPLUNKHEC_OPTION_token=${SPLUNKHEC_OPTION_token}

# Install the daemonset
kubectl apply -f https://raw.githubusercontent.com/missioncriticalkubernetes/fk8splunk/master/kubernetes/install-latest.yaml

# Optionally install RBAC-rolebinding
kubectl apply -f https://raw.githubusercontent.com/missioncriticalkubernetes/fk8splunk/master/kubernetes/rbac-latest.yaml
```

## In-cluster HTTP Event Collector

Can't enable an HTTP Event Collector on your Splunk? Stuck with traditional forwarding on port 9997? No problem! Just install a simple HTTP Event Collector in your cluster! This will in turn forward logs using the splunk-forwarder protocol on port 9997.

```
kubectl apply -f https://raw.githubusercontent.com/missioncriticalkubernetes/fk8splunk/master/kubernetes/splunk-hec-forwarder.yaml
```

The forwarder will be configured with the value of `SPLUNKHEC_OPTION_token` from the `fk8splunk` secret.
