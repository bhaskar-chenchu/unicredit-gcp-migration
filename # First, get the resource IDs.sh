# First, get the resource IDs
VNET_ID=$(az network vnet show -g rg-eu-swc-ach-genai-pov -n eu-swc-ach-vnet --query id -o tsv)
PUBLIC_IP_ID=$(az network public-ip show -g rg-eu-swc-ach-genai-pov -n pip-agw-unionmedi --query id -o tsv)
WAF_POLICY_ID=$(az network application-gateway waf-policy show -g rg-eu-swc-ach-genai-pov --name wafpol-unionmedi --query id -o tsv)

# Then run the validation

az deployment group validate \
  -g rg-eu-swc-ach-genai-pov \
  --template-file appgw-with-waf.json \
  --parameters \
    appGwName="agw-unionmedi-poc" \
    location="swedencentral" \
    vnetId="$(az network vnet show -g rg-eu-swc-ach-genai-pov -n eu-swc-ach-vnet --query id -o tsv)" \
    subnetName="AppGatewaySubnet" \
    publicIpId="$(az network public-ip show -g rg-eu-swc-ach-genai-pov -n pip-agw-unionmedi --query id -o tsv)" \
    wafPolicyId="$(az network application-gateway waf-policy show -g rg-eu-swc-ach-genai-pov --name wafpol-unionmedi --query id -o tsv)" \
    tags='{"Owner":"Bhaskar","Environment":"non-prod","Criticality":"Low"}' \
  -o json --only-show-errors



# Show the exact file you're validating
pwd
ls -la appgw-with-waf.json

# Quick grep to ensure sku is present at top-level (not inside "properties")
grep -n '"sku"' appgw-with-waf.json | sed -n '1,5p'

# OPTIONAL: pretty-print just the "sku" and "sslCertificates" fields if you have jq
jq '.resources[0].sku, .resources[0].properties.sslCertificates' appgw-with-waf.json



export MSYS2_ARG_CONV_EXCL="*"

# Validate (prints exact policy errors if any)
az deployment group validate \
  -g rg-eu-swc-ach-genai-pov \
  --template-file appgw-with-waf.json \
  --parameters @appgw-params.json \
  -o json --only-show-errors

# Create (if validation succeeds)
az deployment group create \
  -g rg-eu-swc-ach-genai-pov \
  --name deploy-appgw-with-waf \
  --template-file appgw-with-waf.json \
  --parameters @appgw-params.json \
  --only-show-errors
---------------


