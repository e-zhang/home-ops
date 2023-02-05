{
  apiVersion: 'projectcontour.io/v1',
  kind: 'HTTPProxy',
  metadata: {
    name: 'vault',
    namespace: 'vault',
  },
  spec: {
    virtualhost: {
      fqdn: 'vault.vault',
    },
    routes: [
      {
        services: [
          {
            name: 'vault',
            port: 8200,
            validation: {
              caSecret: 'vault-tls',
              subjectName: 'vault.vault',
            },
          },
        ],
      },
    ],
  },
}
