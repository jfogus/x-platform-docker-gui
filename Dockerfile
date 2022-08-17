FROM centos:latest

# Fix Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist
# per https://techglimpse.com/failed-metadata-repo-appstream-centos-8/
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum update -y

RUN dnf install -y glibc-locale-source
RUN  localedef --no-archive -i en_US -f UTF-8 en_US.UTF-8 && \
     export LANG=en_US.UTF-8

RUN  dnf install -y dbus-x11 mesa-libGL mesa-libEGL PackageKit-gtk3-module libcanberra-gtk2 firefox mesa-utils and libgl1-mesa-glx
RUN export $(dbus-launch)
RUN  dbus-uuidgen > /etc/machine-id

CMD  /usr/bin/firefox