> REF
> - https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/
> - https://kind.sigs.k8s.io/docs/user/quick-start/
> - https://github.com/kubernetes-sigs/cloud-provider-kind?tab=readme-ov-file#install

# 1. Kind cluster + cloud-provider-kind

```bash
kind create cluster --config kind-config.yaml
cloud-provider-kind
```

# 2. Knative eventing

```bash
k apply -f https://github.com/knative/eventing/releases/download/knative-v1.19.0/eventing-crds.yaml
k apply -f https://github.com/knative/eventing/releases/download/knative-v1.19.0/eventing.yaml
```

or

```bash
k apply -f ./eventing
```

# 3. Verify installation

```bash
k get pods -n knative-eventing -w
```

# 4. Sample

```bash
# no filter
k apply -f ./sample/cloudevents-player-1.yaml

# with filter [type:cloudevents.meo]
k apply -f ./sample/cloudevents-player-2.yaml

# check mate
k get sinkbindings.sources.knative.dev -A

NAMESPACE   NAME                SINK                                                                              AGE   READY   REASON
default     ce-filter-binding   http://broker-ingress.knative-eventing.svc.cluster.local/default/filter-broker    23s   True    
default     ce-player-binding   http://broker-ingress.knative-eventing.svc.cluster.local/default/example-broker   14m   True    

k get brokers.eventing.knative.dev -A

NAMESPACE   NAME             URL                                                                               AGE   READY   REASON
default     example-broker   http://broker-ingress.knative-eventing.svc.cluster.local/default/example-broker   14m   True    
default     filter-broker    http://broker-ingress.knative-eventing.svc.cluster.local/default/filter-broker    28s   True    

k get triggers.eventing.knative.dev -A

NAMESPACE   NAME                        BROKER           SUBSCRIBER_URI                                        AGE   READY   REASON
default     cloudevents-player-filter   filter-broker    http://cloudevents-player.default.svc.cluster.local   36s   True    
default     cloudevents-trigger         example-broker   http://cloudevents-player.default.svc.cluster.local   14m   True
```

- ping source

```bash
k apply -f ./sample/ping-demo.yaml
k logs -n ping-demo -l app=event-display -f
```

- s3 source (minio)

```bash
helm repo add minio https://charts.min.io/
helm repo update minio
helm upgrade --install minio minio/minio --namespace minio --create-namespace --values ./sample/minio-values.yaml --version 5.0.10
k apply -f ./sample/minio-demo.yaml
k logs -n s3-demo -l app=event-display -f
```

- apiserver source + capi: [log-received](./output/event-display-d9889cbb5-q4s5s.log)
```bash
# installed clusterctl + --infra docker
k apply -f ./sample/capi-quickstart-source.yaml
k apply -f ./sample/capi-quickstart.yaml
k logs -n capi -l app=event-display -f
```