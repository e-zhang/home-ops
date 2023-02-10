local certs = import 'certificates.libsonnet';
local helm = import 'helm.libsonnet';
local httpproxy = import 'httpproxy.libsonnet';
local ns = import 'ns.libsonnet';
local pv = import 'pv.libsonnet';


function(bootstrap='false')
  [
    pv,
    ns,
    httpproxy,
  ] + helm.render(bootstrap == 'true') + certs
