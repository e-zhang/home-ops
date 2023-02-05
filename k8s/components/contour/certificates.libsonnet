local contourcert = {
  apiVersion: 'cert-manager.io/v1',
  kind: 'Certificate',
  metadata: {
    name: 'contourcert',
    namespace: 'projectcontour',
  },
  spec: {
    secretName: 'contourcert',
    duration: '2160h',  //90d
    renewBefore: '360h',  //15d
    isCA: false,
    commonName: 'contour',
    privateKey: {
      algorithm: 'RSA',
      encoding: 'PKCS1',
      size: 2048,
    },
    dnsNames: ['contour', 'contour.projectcontour', 'contour.projectcontour.svc', 'contour.projectcontour.svc.cluster.local'],
    issuerRef: {
      kind: 'ClusterIssuer',
      name: 'internal-issuer',
    },
  },
};

local envoycert = {
  apiVersion: 'cert-manager.io/v1',
  kind: 'Certificate',
  metadata: {
    name: 'envoycert',
    namespace: 'projectcontour',
  },
  spec: {
    secretName: 'envoycert',
    duration: '2160h',  //90d
    renewBefore: '360h',  //15d
    isCA: false,
    commonName: 'envoy',
    privateKey: {
      algorithm: 'RSA',
      encoding: 'PKCS1',
      size: 2048,
    },
    dnsNames: ['envoy', 'envoy.projectcontour', 'envoy.projectcontour.svc', 'envoy.projectcontour.svc.cluster.local'],
    ipAddresses: ['127.0.0.1'],
    issuerRef: {
      kind: 'ClusterIssuer',
      name: 'internal-issuer',
    },
  },
};

[contourcert, envoycert]
