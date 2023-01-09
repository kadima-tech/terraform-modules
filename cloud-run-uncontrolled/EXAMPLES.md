# Examples

The README.md has all the available variables but below are some simple examples of using the service

## A publicly accessible service

Publicly accessible to everyone, attached to our vpc so it can talk to private services

```
module "my-public-service" {
  project = data.google_project.veed_project.project_id
  source  = "../modules/cloud-run-uncontrolled"
  name    = "my-public-service"

# Allows it to be accessed by unauthenticated public users, also causes a public url to be generated
# You probably want to give it a real domain name
  allow_unauthenticed_access = true

# Also tell the ingress to allow traffic from the outside world
  ingress = "all"

# scale up and down settings
  min_instances = 1
  max_instances = 3

# passed through as env vars to the running container
  env = [
    { key = "VEED_SITE_ENDPOINT", value = local.env["services"]["my-public-service"]["veed_site_endpoint"] }
  ]

  vpc_connector_name = module.internal-vpc-connector.name

  depends_on = [module.cloudrun]
}
```

## A private service

Only callable by other services on our vpc with named iam accounts

```
module "my-public-service" {
  project = data.google_project.veed_project.project_id
  source  = "../modules/cloud-run-uncontrolled"
  name    = "my-public-service"

# scale up and down settings
  min_instances = 1
  max_instances = 3

# passed through as env vars to the running container
  env = [
    { key = "VEED_SITE_ENDPOINT", value = local.env["services"]["my-public-service"]["veed_site_endpoint"] }
  ]

  vpc_connector_name = module.internal-vpc-connector.name

  depends_on = [module.cloudrun]
}
```

## A private service that is attachable to our load balancers

Exposes a load balancer backend allowing us to expose this as url on our main load balancers. Most of the time this is what you want rather than a public service.

```
module "url-rewriter-service" {
  project = data.google_project.veed_project.project_id
  source  = "../modules/cloud-run-uncontrolled"
  name    = "url-rewriter"

  # causes the load balancer bits to be created
  loadbalancer_backend_create = true

  # allow the service to be accessed from something other than named accounts
  allow_unauthenticed_access = true

  # Allow the load balancer to access the service
  ingress  = "internal-and-cloud-load-balancing"

  min_instances = local.env["services"]["url-rewriter"]["min_instances"]
  max_instances = local.env["services"]["url-rewriter"]["max_instances"]
  env = [
    { key = "VEED_SITE_ENDPOINT", value = local.env["services"]["url-rewriter"]["veed_site_endpoint"] }
  ]

  vpc_connector_name = module.internal-vpc-connector.name

  depends_on = [module.cloudrun]
}
```
