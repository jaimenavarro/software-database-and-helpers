# Rabbit Cluster

## Docker Install / Uninstall
```
docker-compose -f docker-compose-rabbit-cluster.yml up
```

```
docker-compose -f docker-compose-rabbit-cluster.yml down
docker volume prune
```

## Helm Install / Uninstall
* Reference: 
[https://artifacthub.io/packages/helm/bitnami/rabbitmq/8.9.2](https://artifacthub.io/packages/helm/bitnami/rabbitmq/8.9.2). CHART version: **8.9.2**. App version:  **3.8.11**
* **WARNING:** Define *storageClass* for your environment.

```
helm upgrade rabbit-cluster rabbitmq-8.9.2.tgz -f rabbitmq-cluster.yaml -i --debug --wait --timeout 10m
```

```
helm uninstall rabbit-cluster
kubectl delete pvc -l "app.kubernetes.io/instance=rabbit-cluster"
```


# Rabbit Standalone

## Helm Install / Uninstall

```
helm upgrade rabbit rabbitmq-standalone.tgz -f values.yaml -i --debug --wait --timeout 10m
```

```
helm uninstall rabbit
kubectl delete pvc -l "chart=rabbitmq-0.0.1"
```