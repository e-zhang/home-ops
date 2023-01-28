{
  apiVersion: 'cert-manager.io/v1',
  kind: 'Certificate',
  metadata: {
    name: 'vault-tls',
    namespace: 'vault',
  },
  spec: {
    secretName: 'vault-tls',
    duration: '2160h',  //90d
    renewBefore: '360h',  //15d
    isCA: false,
    commonName: 'vault.lab.home',
    privateKey: {
      algorithm: 'RSA',
      encoding: 'PKCS1',
      size: 2048,
    },
    dnsNames: ['vault.lab.home', 'vault.vault', 'vault', 'vault.vault.svc.cluster.local'],
    ipAddresses: ['127.0.0.1'],
    issuerRef: {
      kind: 'Issuer',
      name: 'vault-issuer',
    },
  },
}
