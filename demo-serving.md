# Knative Serving on Kind

> REF
> - https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/
> - https://kind.sigs.k8s.io/docs/user/quick-start/
> - https://github.com/kubernetes-sigs/cloud-provider-kind?tab=readme-ov-file#install

# 1. Kind cluster + cloud-provider-kind

```bash
kind create cluster --config kind-config.yaml
cloud-provider-kind
```

# 2. Knative Serving + Networking layer (Kourier) + DNS configuration

```bash
k apply -f https://github.com/knative/serving/releases/download/knative-v1.19.0/serving-crds.yaml
k apply -f https://github.com/knative/serving/releases/download/knative-v1.19.0/serving-core.yaml
k apply -f https://github.com/knative-extensions/net-kourier/releases/download/knative-v1.19.0/kourier.yaml
```

or

```bash
k apply -f ./serving
```

then

```bash
k patch configmap/config-network --namespace knative-serving --type merge --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'
k apply -f https://github.com/knative/serving/releases/download/knative-v1.19.0/serving-default-domain.yaml
```

# 3. Verify installation

```bash
k get pods -n knative-serving -w
```

# 4. Sample

```bash
k apply -f ./sample/knative-hello-1.yaml
k get routes.serving.knative.dev -Aw
curl "$(kn service describe hello -o url)"

k apply -f ./sample/knative-hello-2.yaml
curl "$(kn service describe hello -o url)"

k apply -f ./sample/knative-hello-3.yaml
./sample/knative-serving.sh

# check mate
k get revisions.serving.knative.dev -A
k get routes.serving.knative.dev -A
```

# 5. Clean up

```bash
kind delete cluster -n app-cluster
```