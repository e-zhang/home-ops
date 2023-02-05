# K3d

Running k3d on rootless docker.

First setup Docker to run [rootless](https://docs.docker.com/engine/security/rootless/).

Tried to run `k3d create cluster` with resource limits. This failed because docker could not set `cpuset` in `cgroups`. Followed instructions to delegate cpuset controller [here](https://docs.docker.com/engine/security/rootless/#limiting-resources).

`k3s` failed when passing `--rootless` because there was no user set by `k3d` (see [enhancement](https://github.com/k3d-io/k3d/issues/573)). Running `k3s` with rootless appears to assume `k3s` runs in a user namespace, but k3d runs it as `root` in the docker container. Given docker itself is running as rootless, this extra flag may not be necessary as the `k3s` container can assume its running as root in the docker rootless environment.

Without `--rootless` the k3d cluster is created but the kube api fails to start. The log shows errors similar to [#1178](https://github.com/k3d-io/k3d/issues/1178), which suggest issues with `br_netfilter`. Follow instructions [here](https://github.com/NVIDIA/deepops/blob/master/docs/container/docker-rootless.md) to load the kernel module.

Next failure,
``` 
level=fatal msg="kubelet exited: failed to run Kubelet: failed to create kubelet: open /dev/kmsg: no such file or directory" 
```

Following  instructions [here](https://github.com/k3s-io/k3s/issues/2054#issuecomment-663087862), tried to set `kernel.dmesg_restrict=0` but that didn't work. Might need to run `--rootless` inside a rootful docker container.


Following
* https://github.com/nestybox/sysbox/issues/70



# Containerd rootless

`nerdctl` unable to spin up container images with container networks. Had to change the `backend` in the cni config to `iptables` from `firewalld`.
