# Google Cloud SQL Auth Proxy Kubernetes deployment

This module deploys a standalone instance of [Google Cloud SQL Auth proxy](https://github.com/GoogleCloudPlatform/cloudsql-proxy)

We advice against deploying this as a standalone service, see Google's [Use the Cloud SQL Auth proxy in a production environment](https://cloud.google.com/sql/docs/postgres/sql-proxy#production-environment). It's likely you want to instead declare a sidecar for `anaml-server` if you use Google Cloud SQL.

This module is available primarily for debug purposes where you want to connect to the Google Cloud SQL database manually. In which case it's recommended you forward the port locally instead of enabling a Kubernetes Service:

```
NAMESPACE=anaml-dev
POD=$(kubectl -n $NAMESPACE get pods -l 'app.kubernetes.io/name=cloudsql-proxy' -o name)
kubectl -n anaml-dev port-forward $POD 5432:5432

psql -h 127.0.0.1 -p 5432 anaml anaml
```
