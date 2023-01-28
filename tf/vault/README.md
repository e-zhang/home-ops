# Bootstrap

`port-forward` to the vault pod and run `vault operator init` with 1 share. 
Copy out the unseal key and root token to bootstrap. Save the root token to ~/.vault-token.

Run terraform in the admin directory to bootstrap the userpass auth method for the admin and totp.

Grab the entity id of the admin and the method id of the mfa method from tf output.

Generate the otp url

```
vault write identity/mfa/method/totp/admin-generate method_id=$METHOD_ID entity_id=$ENTITY_ID 
```

The terraform provider doesn't set qr size so no barcode is returned.

Run `qrencode` to generate a QR Code for the url.


Login with `userpass` and revoke the root token.


## TLS

Bootstrap TLS using Kubernetes CA ([tutorial](https://developer.hashicorp.com/vault/docs/platform/k8s/helm/examples/standalone-tls))

Run the `k8s/scripts/bootstrap-tls.sh` to generate the initial tls secret.

Grab the k8s ca cert for other tf commands

```
kubectl -n vault get secret vault-bootstrap-tls -o=jsonpath='{.data.ca\.crt}' | base64 -d > vault.ca.crt
```

Deploy vault with the bootstrap tls
```
qbec apply lab -c vault -k statefulset -k issuer --vm:tla-str bootstrap=true
```

Replace bootstrapped certificate with certmanager by running 

```
qbec apply lab -c vault -k certificate
```

Redeploy vault to use the non bootstrapped tls
```
qbec apply lab -c vault -k statefulset
```

Recreate the issuer to confirm it can connect to vault
```
kubectl -n vault delete issuer vault-issuer
qbec apply lab -c vault -k issuer
```

Reset the CA cert for `tf` providers.

```
kubectl -n vault get secret vault-tls -o=jsonpath='{.data.ca\.crt}' | base64 -d > vault.ca.crt
```

## PKI

Setup PKI by running `terraform apply` to generate the `csr`.

Get the csr

```
 terraform show -json | jq '.values["root_module"]["resources"][].values.csr' -r | grep -v null > ~/Documents/work/pki/lab/lab.csr
```

Run certstrap to sign the key with the offline root 
```
certstrap sign --expires "1 year" --csr lab/lab.csr --cert lab/lab.crt --intermediate --path-length "1" --CA "Lab Root" "EZ Lab v2023"
```

Generate the full CA chain
```
cat lab/lab.crt out/Lab_Root.crt > lab/lab_full.crt
```

Rerun `terraform apply` with the signed cert file
```
terraform apply --var signed_cert_file=~/Documents/work/pki/lab/lab_full.crt
```
