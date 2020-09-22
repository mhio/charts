# mhio helm repo

```
helm repo add mhio https://mhio.github.io/charts/
```

#@ gogs
```
helm upgrade --install mygogs mhio/gogs -f mygogs.values.yaml
```

Common values:
```
service:
  ingress:
    enabled: true
    annotations:
      "ingress.kubernetes.io/proxy-body-size": "100m"
    hosts:
    - "git.something.com"
    tls:
      hosts:
      - "git.something.com"
  sshDomain: "git.something.com"
  gogs:
    repositoryUploadMaxFileSize: 100
    repositoryUploadMaxFiles: 300
    serverDomain: "git.something.com"
    serverRootUrl: "https://git.something.com/"
    securitySecretKey: "somethingKeyName"
```
