locals {
  api_mgmt_suffix = var.apim_suffix == "" ? var.env : var.apim_suffix
  api_mgmt_name   = "cft-api-mgmt-${local.api_mgmt_suffix}"
  api_mgmt_rg     = join("-", ["cft", var.env, "network-rg"])

  idam_url      = var.env == "prod" ? "https://hmcts-access.service.gov.uk" : "https://idam-web-public.${var.env}.platform.hmcts.net"
  idam_env      = var.env == "prod" || var.env == "aat" ? "${var.env}2" : var.env
  idam_audience = "fpl-case-service"
  oidc_issuer   = "https://forgerock-am.service.core-compute-idam-${local.idam_env}.internal:8443/openam/oauth2/realms/root/realms/hmcts"

  fpl_key_vault    = join("-", ["fpl", var.env])
  fpl_key_vault_rg = join("-", ["fpl-case-service", var.env])

  s2s_key_vault    = join("-", ["s2s", var.env])
  s2s_key_vault_rg = join("-", ["rpe-service-auth-provider", var.env])
  s2s_client_id    = "api-gw"

  fpl_api_url = join("", ["http://fpl-case-service-", var.env, ".service.core-compute-", var.env, ".internal"])
  s2sUrl      = join("", ["http://rpe-service-auth-provider-", var.env, ".service.core-compute-", var.env, ".internal"])

}

provider "azurerm" {
  alias           = "aks-cftapps"
  subscription_id = var.aks_subscription_id
  features {}
}

data "azurerm_key_vault" "fpl_key_vault" {
  name                = local.fpl_key_vault
  resource_group_name = local.fpl_key_vault_rg
}

#data "azurerm_key_vault_secret" "s2s_client_id" {
#  name         = "gateway-s2s-client-id"
#  key_vault_id = data.azurerm_key_vault.fpl_key_vault.id
#}

#data "azurerm_key_vault_secret" "s2s_client_secret" {
#    name         = "gateway-s2s-client-secret"
#  key_vault_id = data.azurerm_key_vault.fpl_key_vault.id
#}

data "azurerm_key_vault" "s2s_key_vault" {
  name                = local.s2s_key_vault
  resource_group_name = local.s2s_key_vault_rg
}

#data "azurerm_key_vault_secret" "s2s_client_id" {
#  name         = "gateway-s2s-client-id"
#  key_vault_id = data.azurerm_key_vault.s2s_key_vault.id
#}

data "azurerm_key_vault_secret" "s2s_client_secret" {
  name         = "microservicekey-api-gw"
  key_vault_id = data.azurerm_key_vault.s2s_key_vault.id
}
