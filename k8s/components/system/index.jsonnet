[
  {
    apiVersion: 'storage.k8s.io/v1',
    kind: 'StorageClass',
    metadata: {
      name: 'local-storage',
      namespace: 'lab-system',
    },
    provisioner: 'kubernetes.io/no-provisioner',
    volumeBindingMode: 'WaitForFirstConsumer',
    reclaimPolicy: 'Retain',
  },
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'IngressClass',
    metadata: {
      name: 'contour',
      namespace: 'lab-system',
      labels: {
        'app.kubernetes.io/component': 'controller',
      },
      annotations: {
        'ingressclass.kubernetes.io/is-default-class': 'true',
      },
    },
    spec: {
      controller: 'projectcontour.io/ingress-controller',
    },
  },
]
