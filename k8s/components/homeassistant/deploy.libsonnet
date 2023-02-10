local git_sync =
  {
    image: 'alpine/git:user',
    imagePullPolicy: 'IfNotPresent',
    name: 'git-init',
    volumeMounts: [
      {
        name: 'ssh',
        mountPath: '/.ssh/',
        readOnly: true,
      },
      {
        name: 'config',
        mountPath: '/config',
      },
    ],
    workingDir: '/config',
    env: [
      {
        name: 'GIT_SSH_COMMAND',
        value: 'ssh -i /.ssh/ssh-privatekey -o UserKnownHostsFile=/.ssh/known_hosts',
      },
    ],
    command: ['/bin/sh', '-c'],
    args: [
      'git pull || git clone git@github.com:e-zhang/homeassistant-config.git',
    ],
  };

local deploy = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    labels: {
      app: 'homeassistant',
    },
    name: 'homeassistant',
    namespace: 'homeassistant',
  },

  spec: {
    selector: {
      matchLabels: {
        app: 'homeassistant',
      },
    },
    template: {
      metadata: {
        labels: {
          app: 'homeassistant',
        },
      },
      spec: {
        initContainers: [
          git_sync,
        ],
        containers: [
          {
            image: 'ghcr.io/home-assistant/home-assistant:stable',
            imagePullPolicy: 'Always',
            name: 'homeassistant',
            env: [
              {
                name: 'TZ',
                value: 'TZ=America/Los_Angeles',
              },
              {
                name: 'MPLCONFIGDIR',
                value: '/config/matplotlib',
              },
            ],
            ports: [
              {
                containerPort: 8123,
                protocol: 'TCP',
              },
            ],
            volumeMounts: [
              {
                name: 'localtime',
                mountPath: '/etc/localtime',
                readOnly: true,
              },
              {
                name: 'config',
                mountPath: '/config',
              },
            ],
          },
        ],
        restartPolicy: 'Always',
        volumes: [
          {
            name: 'config',
            persistentVolumeClaim: {
              claimName: 'config',
            },
          },
          {
            name: 'localtime',
            hostPath: {
              path: '/etc/localtime',
            },
          },
          {
            name: 'ssh',
            secret: {
              secretName: 'ssh-key-git',
            },
          },
        ],
        securityContext: {
          runAsUser: 1000,
          runAsGroup: 1000,
        },
      },
    },
  },
};

local svc = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'homeassistant',
    namespace: 'homeassistant',
  },
  spec: {
    selector: {
      app: 'homeassistant',
    },
    ports: [
      {
        protocol: 'TCP',
        port: 8123,
        name: 'http',
      },
    ],
  },
};

[
  deploy,
  svc,
]
