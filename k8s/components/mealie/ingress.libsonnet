local ingress = {
  apiVersion: 'networking.k8s.io/v1',
  kind: 'Ingress',
  metadata: {
    name: 'mealie',
    namespace: 'mealie',
    annotations: {
      'cert-manager.io/cluster-issuer': 'ingress-issuer',
      'cert-manager.io/common-name': 'mealie.lab.home',
    },
  },
  spec: {
    tls: [
      {
        hosts: ['mealie.lab.home'],
        secretName: 'mealie-tls',
      },
    ],
    rules: [
      {
        host: 'mealie.lab.home',
        http: {
          paths: [
            {
              path: '/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: 'mealie',
                  port: {
                    number: 3000,
                  },
                },
              },
            },
            {
              path: '/api/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: 'mealie',
                  port: {
                    number: 9000,
                  },
                },
              },
            },
          ],
        },
      },
    ],
  },
};

[ingress]
