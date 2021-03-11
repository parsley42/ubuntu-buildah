FROM mirror.gcr.io/library/ubuntu:latest

RUN . /etc/os-release && \
  apt-get update && \
  apt-get install -y \
    curl \
    gnupg && \
  echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${NAME}_${VERSION_ID}/ /" > /etc/apt/sources.list.d/kubic.list && \
  curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${NAME}_${VERSION_ID}/Release.key  | apt-key add - && \
  apt-get update && \
  apt-get install -y \
    buildah \
    fuse-overlayfs \
    libcap2-bin && \
  rm -rf /var/lib/apt/lists/*

# THIS is the "special sauce" to make this work in my Kubernetes
# cluster. Pretty much everything else came from other CentOS/Fedora
# containerfiles.
RUN chmod u-s /usr/bin/new*idmap && \
  setcap CAP_SETGID+ep /usr/bin/newgidmap && \
  setcap CAP_SETUID+ep /usr/bin/newuidmap

# Set an environment variable to default to chroot isolation for RUN
# instructions and "buildah run".
ENV BUILDAH_ISOLATION=chroot

COPY containers.conf /etc/containers/containers.conf

# Adjust storage.conf to enable Fuse storage.
RUN chmod 644 /etc/containers/containers.conf && \
  sed -i \
    -e 's|^#mount_program|mount_program|g' \
    -e '/additionalimage.*/a "/var/lib/shared",' \
    -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
    /etc/containers/storage.conf && \
  mkdir -p \
    /var/lib/shared/overlay-images \
    /var/lib/shared/overlay-layers \
    /var/lib/shared/vfs-images \
    /var/lib/shared/vfs-layers && \
  touch \
    /var/lib/shared/overlay-images/images.lock \
    /var/lib/shared/overlay-layers/layers.lock \
    /var/lib/shared/vfs-images/images.lock \
    /var/lib/shared/vfs-layers/layers.lock
