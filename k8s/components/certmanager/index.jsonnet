local cert = import 'certmanager.libsonnet';
local ns = import 'ns.libsonnet';


[ns] + cert
