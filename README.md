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
# Create a secret to hold your Splunk configuration
kubectl -n kube-system create secret generic fk8splunk --from-literal=SPLUNK_HOST=splunk.kube-system --from-literal=SPLUNK_PORT=8088 --from-literal=SPLUNK_INDEX=main --from-literal=SPLUNK_TOKEN=00000000-0000-0000-0000-000000000000

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

The default token is `00000000-0000-0000-0000-000000000000`.
