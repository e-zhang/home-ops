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

