# Redis Cluster

## Docker Install / Uninstall

```
cd ./redis-cluster/docker-compose
docker-compose -f docker-compose-redis-cluster.yml up
```

```
docker-compose -f docker-compose-redis-cluster.yml down
docker volume prune
```

## Helm Install / Uninstall
* Reference: 
[https://artifacthub.io/packages/helm/bitnami/redis-cluster/4.4.1](https://artifacthub.io/packages/helm/bitnami/redis-cluster/4.4.1). CHART version: **4.3.1**. App version:  **6.0.10**
* **WARNING:** Define *storageClass* for your environment.

```
cd ./redis-cluster/helm
helm upgrade redis-cluster redis-cluster-4.3.1.tgz -f redis-cluster.yaml -i --debug --wait --timeout 10m
```

```
helm uninstall redis-cluster
kubectl delete pvc,job -l "app.kubernetes.io/name=redis-cluster"
```

