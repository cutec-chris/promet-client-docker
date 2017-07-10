A dockerized Variant of Promet-ERP
----------------------------------
 
Persist Data
 docker run --publish 10088:8080 --volume /my-docker-data-dir/promet:/srv/promet promet-client 
 
 
- [Introduction](#introduction)
    - [Changelog](Changelog.md)
- [Issues](#issues)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Available Configuration Parameters](#available-configuration-parameters)
    - [Data Store](#data-store)
    - [Database](#database)
        - [PostgreSQL (Recommended)](#postgresql)
            - [External PostgreSQL Server](#external-postgresql-server)
            - [Linking to PostgreSQL Container](#linking-to-postgresql-container)

# Introduction

Dockerfile to run Promet-ERP [promet-ERP](http://www.free-erp.de) GUI Client from an container image.

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Be a part of the community and help resolve [Issues](https://github.com/cutec-chris/promet-erp/issues)

# Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

Install the most recent version of the Docker Engine for your platform using the [official Docker releases](http://docs.docker.com/engine/installation/), which can also be installed using:

```bash
wget -qO- https://get.docker.com/ | sh
```

Fedora and RHEL/CentOS users should try disabling selinux with `setenforce 0` and check if resolves the issue. If it does than there is not much that I can help you with. You can either stick with selinux disabled (not recommended by redhat) or switch to using ubuntu.

You may also set `DEBUG=true` to enable debugging of the entrypoint script, which could help you pin point any configuration issues.

If using the latest docker version and/or disabling selinux does not fix the issue then please file a issue request on the [issues](https://github.com/sameersbn/docker-gitlab/issues) page.

In your issue report please make sure you provide the following information:

- The host distribution and release version.
- Output of the `docker version` command
- Output of the `docker info` command
- The `docker run` command you used to run the image (mask out the sensitive bits).

# Prerequisites

Your docker host needs to have 300MB or more of available RAM to run Promet-ERP.

# Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/cutec/promet-client) and is the recommended method of installation.

```bash
docker pull cutec/promet-client:latest
```

Alternatively you can build the image locally.

```bash
docker build -t cutec/promet-client github.com/cutec-chris/promet-erp
```

# Quick Start

Step 1. Launch the promet container

```bash
docker run --publish 10088:8080 cutec/promet-client
```

Point your browser to `http://localhost:10088` and go through the Mandant Wizard to create and Database and prefill it with an Profile.

You should now have the Promet-ERP application up and ready for testing. If you want to use this image in production then please read on.

# Configuration

## Data Store

promet-ERP is an (Article,Contact,Project,Document) Management Software and as such you don't want to lose your Data when the docker container is stopped/deleted. To avoid losing any data, you should mount a volume at,

* `/srv/promet`

SELinux users are also required to change the security context of the mount point so that it plays nicely with selinux.

```bash
mkdir -p /srv/docker/promet
sudo chcon -Rt svirt_sandbox_file_t /srv/docker/promet
```

Volumes can be mounted in docker by specifying the `-v` option in the docker run command.

```bash
docker run --name promet-erp -d \
    --publish 10088:8080 \
    --volume /srv/docker/promet:/srv/promet \
    cutec/promet-client:latest
```

## Upgrading

- **Step 1**: Update the docker image.

```bash
docker pull cutec/promet-client:latest
```

- **Step 2**: Stop and remove the currently running image

```bash
docker stop promet-erp
docker rm promet-erp
```

- **Step 4**: Start the image

```bash
docker run --name promet-erp -d [OPTIONS] cutec/promet-client:latest
```

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using docker version `1.3.0` or higher you can access a running containers shell using `docker exec` command.

```bash
docker exec -it promet-erp bash
```

# References

* https://github.com/cutec-chris/promet-erp
* http://www.free-erp.de
