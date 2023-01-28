local helm = importstr 'data://expand-helm/components/vault/include/helm.yaml?chart=hashicorp/vault&name=vault&ns=vault';

local objs = std.parseYaml(helm);

local bootstrapSecret = function(s)
  s +
  if std.objectHas(s, 'secret') && s.secret.secretName == 'vault-tls' then {
    secret+: { secretName: 'vault-bootstrap-tls' },
  }
  else {};

local render = function(bootstrap)
  [
    if x.kind == 'StatefulSet' then x {
      spec+: {
        volumeClaimTemplates: [
          x.spec.volumeClaimTemplates[0] {
            spec+: {
              selector: {
                matchLabels: {
                  app: 'vault',
                },
              },
            },
          },
        ],
      },
    } + if bootstrap then {
      spec+: {
        template+: {
          spec+: {
            volumes: std.map(bootstrapSecret, x.spec.template.spec.volumes),
          },
        },
      },
    } else {}
    else if x.kind == 'Pod' then {}
    else x
    for x in objs
  ];

{
  render:: render,
}
