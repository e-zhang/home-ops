[
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'IngressClass',
    metadata: {
      name: 'contour',
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
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      name: 'oidc-cluster-admin',
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: 'cluster-admin',
    },
    subjects: [
      {
        apiGroup: 'rbac.authorization.k8s.io',
        kind: 'Group',
        name: 'oidc:kube_admins',
      },
    ],
  },
  {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: 'terraform',
    },
  },
]
