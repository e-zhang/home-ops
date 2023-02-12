local ingress = {
  apiVersion: 'networking.k8s.io/v1',
  kind: 'Ingress',
  metadata: {
    name: 'homeassistant',
    namespace: 'homeassistant',
    annotations: {
      'cert-manager.io/cluster-issuer': 'ingress-issuer',
      'cert-manager.io/common-name': 'homeassistant.lab.home',
      'projectcontour.io/websocket-routes': '/api/websocket',
    },
  },
  spec: {
    tls: [
      {
        hosts: ['homeassistant.lab.home'],
        secretName: 'homeassistant-tls',
      },
    ],
    rules: [
      {
        host: 'homeassistant.lab.home',
        http: {
          paths: [
            {
              path: '/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: 'homeassistant',
                  port: {
                    number: 8123,
                  },
                },
              },
            },
            // list out websocket path explicitly to upgrade handling in envoy
            {
              path: '/api/websocket',
              pathType: 'Exact',
              backend: {
                service: {
                  name: 'homeassistant',
                  port: {
                    number: 8123,
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
