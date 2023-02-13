local deploy = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: 'mealie',
    },
    name: 'mealie',
    namespace: 'mealie',
  },
  spec: {
    selector: {
      matchLabels: {
        app: 'mealie',
      },
    },
    replicas: 1,
    template: {
      metadata: {
        labels: {
          app: 'mealie',
        },
      },
      spec: {
        containers: [
          {
            image: 'hkotel/mealie:omni-nightly',
            imagePullPolicy: 'Always',
            name: 'mealie',
            env: [
              {
                name: 'PUID',
                value: '1000',
              },
              {
                name: 'PGID',
                value: '1000',
              },
              {
                name: 'BASE_URL',
                value: 'mealie.lab.home:8443',
              },
              {
                name: 'TZ',
                value: 'America/Los_Angeles',
              },
              {
                name: 'DEFAULT_EMAIL',
                value: 'mealie@lab.home',
              },
              {
                name: 'ALLOW_SIGNUP',
                value: 'false',
              },
              {
                name: 'TOKEN_TIME',
                value: '5040',
              },
            ],
            ports: [
              {
                name: 'http-api',
                containerPort: 9000,
                protocol: 'TCP',
              },
              {
                name: 'http-frontend',
                containerPort: 3000,
                protocol: 'TCP',
              },
            ],
            volumeMounts: [
              {
                name: 'mealie-data',
                mountPath: '/app/data',
              },
            ],
          },
        ],
        restartPolicy: 'Always',
        volumes: [
          {
            name: 'mealie-data',
            persistentVolumeClaim: {
              claimName: 'mealie-pvc',
            },
          },
        ],
        securityContext: {
          runAsUser: 1000,
          runAsGroup: 1000,
          fsGroup: 1000,
        },
      },
    },
  },
};

local svc = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'mealie',
    namespace: 'mealie',
  },
  spec: {
    selector: {
      app: 'mealie',
    },
    ports: [
      {
        protocol: 'TCP',
        port: 3000,
        name: 'http-frontend',
      },
      {
        protocol: 'TCP',
        port: 9000,
        name: 'http-api',
      },
    ],
  },
};

[deploy, svc]
