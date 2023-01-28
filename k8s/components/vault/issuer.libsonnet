local ca = importstr './ca.crt';
local bootstrapCA = importstr './bootstrap-ca.crt';


local render = function(bootstrap)
  [
    {
      apiVersion: 'v1',
      kind: 'ServiceAccount',
      metadata: {
        name: 'certmanager-vault-issuer',
        namespace: 'vault',
      },
    },
    {
      apiVersion: 'v1',
      kind: 'Secret',
      metadata: {
        name: 'vault-issuer-token',
        namespace: 'vault',
        annotations: {
          'kubernetes.io/service-account.name': 'certmanager-vault-issuer',
        },
      },
      type: 'kubernetes.io/service-account-token',
      data: {},
    },
    {
      apiVersion: 'cert-manager.io/v1',
      kind: 'Issuer',
      metadata: {
        name: 'vault-issuer',
        namespace: 'vault',
      },
      spec: {
        vault: {
          path: 'pki/v2023/lab/v2023/sign/lab-vault-role',
          server: 'https://vault.vault:8200',
          caBundle: if bootstrap then bootstrapCA else ca,
          auth: {
            kubernetes: {
              role: 'vault-issuer',
              mountPath: '/v1/auth/kubernetes',
              secretRef: {
                name: 'vault-issuer-token',
                key: 'token',
              },
            },
          },
        },
      },
    },
  ];

{
  render:: render,
}
