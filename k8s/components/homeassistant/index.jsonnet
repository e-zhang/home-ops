local ca = import 'ca.libsonnet';
local deploy = import 'deploy.libsonnet';
local ingress = import 'ingress.libsonnet';
local ns = import 'ns.libsonnet';
local pvc = import 'pvc.libsonnet';
local sa = import 'sa.libsonnet';


local merge(arr, o) =
  arr + (
    if std.isArray(o) then
      o
    else
      [o]
  );


std.foldl(merge, [
  ns,
  sa,
  ca,
  deploy,
  ingress,
  pvc,
], [])
