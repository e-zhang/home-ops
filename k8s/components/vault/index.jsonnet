local cert = import 'certificate.libsonnet';
local helm = import 'helm.libsonnet';
local issuer = import 'issuer.libsonnet';
local ns = import 'ns.libsonnet';
local pv = import 'pv.libsonnet';


function(bootstrap='false')
  [
    pv,
    ns,
    cert,
  ] + helm.render(bootstrap == 'true') + issuer.render(bootstrap == 'true')
