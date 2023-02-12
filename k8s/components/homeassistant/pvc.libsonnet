local pv = {
  apiVersion: 'v1',
  kind: 'PersistentVolume',
  metadata: {
    name: 'homeassistant-config',
    labels: {
      app: 'homeassistant',
    },
  },
  spec: {
    capacity: {
      storage: '10Gi',
    },
    volumeMode: 'Filesystem',
    accessModes: [
      'ReadWriteOnce',
    ],
    persistentVolumeReclaimPolicy: 'Retain',
    storageClassName: 'local-storage',
    'local': {
      path: '/home/home/Documents/work/k3s/storage/homeassistant/config',
    },
    claimRef: {
      name: 'config-pvc',
      namespace: 'homeassistant',
    },
    nodeAffinity: {
      required: {
        nodeSelectorTerms: [
          {
            matchExpressions:
              [{
                key: 'node.kubernetes.io/instance-type',
                operator: 'In',
                values: ['k3s'],
              }],
          },
        ],
      },
    },
  },
};

local pvc = {
  apiVersion: 'v1',
  kind: 'PersistentVolumeClaim',
  metadata: {
    name: 'config-pvc',
    namespace: 'homeassistant',
  },
  spec: {
    accessModes: [
      'ReadWriteOnce',
    ],
    storageClassName: '',
    volumeName: 'homeassistant-config',
    resources: {
      requests: {
        storage: '10Gi',
      },
    },
  },
};

[pv, pvc]
