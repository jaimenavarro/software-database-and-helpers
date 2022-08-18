# Solr Cluster

## Docker Install / Uninstall

```
cd ./solr-cluster/docker-compose
docker-compose -f docker-compose-solr-cluster.yml up
```

```
docker-compose -f docker-compose-solr-cluster.yml down
docker volume prune
```

## Helm Install / Uninstall
* Reference: 
[https://artifacthub.io/packages/helm/preferred-ai/solr/3.0.3](https://artifacthub.io/packages/helm/preferred-ai/solr/3.0.3). CHART version: **solr-3.0.3**. App version:  **8.7.0**
* **WARNING:** Define *storageClass* for your environment.

```
cd ./solr-cluster/helm
helm upgrade solr-cluster solr-3.0.3.tgz -f solr.yaml -i --debug --wait --timeout 10m
```

```
helm uninstall solr-cluster
kubectl delete pvc -l "app.kubernetes.io/instance=solr-cluster"
```

* Confluence to step SolrCloud up quickly.
[https://mirada.atlassian.net/wiki/spaces/BAC/pages/3109290046/Quick+guide+to+set+up+SolrCloud](https://mirada.atlassian.net/wiki/spaces/BAC/pages/3109290046/Quick+guide+to+set+up+SolrCloud)
