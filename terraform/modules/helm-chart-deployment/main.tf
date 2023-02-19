provider "helm" {
  kubernetes {
    host     = var.kube_config.host

    client_certificate     = base64decode(var.kube_config.client_certificate)
    client_key             = base64decode(var.kube_config.client_key)
    cluster_ca_certificate = base64decode(var.kube_config.cluster_ca_certificate)
  }
}

locals {
  chart_path = "${path.module}/../../../helm-chart"
  chart_sha1 = sha1(join("", [for f in fileset(local.chart_path, "**") : filesha1("${local.chart_path}/${f}")]))
}

resource "helm_release" "corda-deployment" {
  name      = "corda"
  namespace = "corda"
  chart     = local.chart_path  
  version   = local.chart_sha1

  create_namespace = true

  set {
    name  = "chartVersion"
    value = local.chart_sha1
    type  = "string"
  }

  values = [<<EOF

env: DEV
name: 'corda-node'
port: 10002

image:
  registry: ${var.acr_login_server}
  name: corda-notary-node

version:
  digest: 'sha256:2ae94e748a1c9839ce7fa7925a42e690f59b8d6998559fb5bb76ae55810f02d7'
  tag: 977cfcb

configmap:
  DATABASE_URL: ${var.database_url}
  DATABASE_USER: ${var.database_user}
  DATASOURCE_CLASS_NAME: org.postgresql.ds.PGSimpleDataSource

secret:
  KEY_STORE_PASSWORD: ${var.key_store_password}
  TRUST_STORE_PASSWORD: ${var.trust_store_password}
  DATABASE_PASSWORD: ${var.database_password}

migrationJob:
  image: corda-notary-node
  digest: 'sha256:2ae94e748a1c9839ce7fa7925a42e690f59b8d6998559fb5bb76ae55810f02d7'
  tag: 977cfcb
  command: ['sh', '-c', 'cd /corda; export BASE_DIR=/corda; java -jar corda.jar run-migration-scripts --core-schemas --app-schemas --base-directory=/corda --config-file=node.conf']

EOF
  ]  

}