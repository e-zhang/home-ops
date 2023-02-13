local deploy = import 'deploy.libsonnet';
local ingress = import 'ingress.libsonnet';
local ns = import 'ns.libsonnet';
local pv = import 'pv.libsonnet';

[ns] + deploy + pv + ingress
