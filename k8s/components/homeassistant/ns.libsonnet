{
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: 'homeassistant',
    labels: {
      'k8s.lab.home/inject-ca': 'true',
    },
  },
}
