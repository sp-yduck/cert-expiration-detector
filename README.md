# Cert Expiration Detector

Custom plugin for Node-Problem-Detector

Cert Expiration Detector checks certification expiration date on the nodes.

## Configuration

| variable | description | example |
| -------- | ----------- | ------- |
| ssl_dir  | directory including cert files | /etc/kubernetes/pki |
| expiration_threshold_seconds | script will exit with 1 if there are any certs will expire before this seconds | 2592000 (30days) |