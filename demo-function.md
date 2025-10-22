# 1. Setup

- Run [Knative Eventing to Step 3](./demo-eventing.md)
- [https://knative.dev/docs/functions/install-func/](https://knative.dev/docs/functions/install-func/)

# 2. Tekton
```bash
k apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.49.0/release.yaml
```

or

```bash
k apply -f ./function/tekton.yaml
```

then
```bash
k create clusterrolebinding default:knative-serving-namespaced-admin --clusterrole=knative-serving-namespaced-admin  --serviceaccount=default:default
```

# 3. Knative Function Demo

```bash
FUNC_REGISTRY=docker.io/lmhinnel func deploy --remote -p hello --verbose
```