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
  name: 'corda-notary-node'  

version:
  digest: 'sha256:cbc430bbb7f07f52a01dfb21a972aafcd36cd0a9ed7e8247e28be065d353e2da'
  tag: bf6f17c

configmap:
  DATABASE_URL: ${var.database_url}
  DATABASE_USER: postgres    
  DATASOURCE_CLASS_NAME: org.postgresql.ds.PGSimpleDataSource

secret:
  KEY_STORE_PASSWORD: cordacadevpass
  TRUST_STORE_PASSWORD: trustStorePassword
  DATABASE_PASSWORD: ${var.database_password}
EOF
  ]  

}