local deploy = import './deploy.libsonnet';
local ingress = import './ingress.libsonnet';
local ns = import './ns.libsonnet';
local pvc = import './pvc.libsonnet';
local ssh = import './ssh.libsonnet';


local merge(arr, o) =
  arr + (
    if std.isArray(o) then
      o
    else
      [o]
  );


std.foldl(merge, [
  ns,
  deploy,
  ingress,
  pvc,
  ssh,
], [])
