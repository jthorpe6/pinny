# pinny

A ssl pinning example app

## cert pinning 

To generate a cert for pinning use this command and update the references in the source.

```bash
echo | openssl s_client -servername jxtx.gitlab.io -connect jxtx.gitlab.io:443 | \
openssl x509 -outform der -out jxtx.gitlab.io.cer
```
