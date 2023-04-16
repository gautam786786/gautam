provider "vault"{}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "dummy" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/dummy"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admin","dummy"],
  "password": "changeme"
}
EOT
}

# URL: http://20.13.90.121:8200/
# export VAULT_TOKEN=hvs.9N1LtEs6DqLvAOEM4ZNYslST
# Apply this and 
# its created 