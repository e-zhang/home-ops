local pvc = {
  apiVersion: 'v1',
  kind: 'PersistentVolumeClaim',
  metadata: {
    name: 'config',
    namespace: 'homeassistant',
    annotations: {
      volumeType: 'local',
    },
  },
  spec: {
    accessModes: [
      'ReadWriteOnce',
    ],
    storageClassName: 'local-path',
    resources: {
      requests: {
        storage: '1Gi',
      },
    },
  },
};

[pvc]
