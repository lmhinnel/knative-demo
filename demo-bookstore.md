```
./kind-config.sh
kubectl apply -f frontend/config/
kubectl apply -f node-server/config/
kubectl port-forward svc/node-server-svc 8080:80
func deploy -b=s2i -v -p sentiment-analysis-app
func deploy -b=s2i -v -p bad-word-filter
k apply -f db-service
# kubectl apply -n camel-k -f https://raw.githubusercontent.com/apache/camel-kamelets/main/kamelets/slack-sink.kamelet.yaml
k apply -f slack-sink
k apply -f ./sample/strimzi.yaml
k apply -f ./sample/kafka.yaml

```