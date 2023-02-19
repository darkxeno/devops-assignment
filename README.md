**DevOps Technical Assignment**

**Docker image**
Please create Docker image for running a Corda 4.9 node.

The node can be bootstrapped using the "network-boostrapper" tool, here you can find documentation and instructions on how to use it:

<https://docs.r3.com/en/platform/corda/4.9/enterprise/network-bootstrapper.html#test-deployments>

The output of the network bootstrapper is a node that can be then containerised.

Use an image that makes sense as the starting point, make sure to add everything needed to have the Node working (requirements are listed in the Docs).

**Docker Compose File**

Please create a docker-compose.yml file that can bring up a Corda node. The Corda node can be bootstrapped. The docker-compose.yml file should include the following:

-   A service that runs the Corda node image.
-   A Postgres Database to which the Node will connect to.

**Helm Chart File**

Please create a Helm chart file that can be used to deploy the Corda node image built previously to a Kubernetes instance. The Helm chart file should include the following:

    A Kubernetes deployment for the Corda node.

    Any additional resources required to support the Corda node, such as a database or network service.

**Terraform File**

Please create a Terraform file that deploys a Kubernetes instance in Azure, a Postgres database, creates a rule so that the instance can connect to the database, and deploys the Helm chart file created in the previous section. The Terraform file should include the following:

    A Kubernetes deployment for the Corda node that uses the Helm chart file created in the next section.

    A database deployment that is compatible with the Corda node.

    A network rule that allows the Kubernetes instance to connect to the database.

**Follow-Up Questions**

Please provide answers to the following follow-up questions:

    How would you secure the RPC port on the Corda node?

    We can encrypt the traffic using the SSL configuration, and expose the port using any of these options, in preference order:

    - If the source and target of the traffic is on the same kubernetes cluster or using private VPC peering and we want to add another layer of protection using mutual TLS, we can use Istio or Envoy.
    - If the source and target of the traffic is on the same kubernetes cluster we could use network policies to define traffic allowance rules: https://kubernetes.io/docs/concepts/services-networking/network-policies/
    - If the source and target of the traffic is using private VPC peering we could use firewall rules to control the traffic
    - Using corda firewall configuration: https://corda.net/blog/corda-firewall%E2%80%8A-%E2%80%8Acomponents-pki-deployment/
    - Using Azure link services: https://learn.microsoft.com/en-us/azure/private-link/private-link-service-overview
    - Using private access by VPN or bastion host
    - Using kubernetes port forwarding or telepresence during admin sessions
    - Using public access with whitelistened public IPs

    Other options could exists depending on the source of the traffic that needs to connect to the RPC port.

    Where are the keys of the Corda node stored, and how are they managed?

    They are currentlt stored on /corda/.secrets file and ignored on .gitignore, the next step should be to configure the required Azure infra to use SOPS and encrypt that file using a key vault key. Once encrypted the file can be added to the git repository safely.
    https://github.com/mozilla/sops#encrypting-using-azure-key-vault