local helm = importstr 'data://expand-helm/components/certmanager/include/helm.yaml?chart=jetstack/cert-manager&name=certmanager&ns=certmanager';

local objs = std.parseYaml(helm);

objs
