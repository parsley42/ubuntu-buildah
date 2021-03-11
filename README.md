# Ubuntu-Buildah

While I had success building containers using `buildah` with a CentOS/Fedora based image in my Kubernetes cluster, I couldn't find an Ubuntu-based image to do the same thing.

## Requirements

This image alone will not make `buildah` work in your Kubernetes cluster. The "special sauce" for my cluster is, roughly:
* Uses the `cri-o` container runtime
* Configures `cri-o` to allow `/dev/fuse` in containers

You can see all the bits I use for building my home cluster in my [ansible-kubernetes-metal-centos8](https://github.com/parsley42/ansible-kubernetes-metal-centos8) repository.
