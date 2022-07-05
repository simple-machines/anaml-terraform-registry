# anaml-routing-not-found service

It's likely you do not want to deploy this!

## What is it?

anaml-routing-not-found service is primarily used in a multi host hosting environment where we want to serve a branded "404 Page Not Found" when a route does not match.

This is mainly used internally for deployments that use a shared Google Global Loadbalancer that requires a default service backend for route misses to server multiple Anaml deployments running off a single Kubernetes cluster.
