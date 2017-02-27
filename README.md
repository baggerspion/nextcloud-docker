# Improved Dockerfile for Nextcloud

## Background

The official Nextcloud Docker image can be found over [at he Docer Hub](https://hub.docker.com/_/nextcloud/). It is not the most popular Nextcloud image. [This is](https://hub.docker.com/r/wonderfall/nextcloud/). The primary complaint I have about the official image is its size: over 600mb! This project exists to provide an alternative image with a much smaller footprint.

## Overall Aims Of This Project

- Provide an image with support for all officially supported apps (no more, no less)
- Provide an image that is as lean and stable as possible
  - The base distribution should be released as stable
  - The image should be based upon packages of the base distribution and not built manually
  
'''Note: this Dockerfile is currently unavailable on Docker Hub as the base image is not yet stable'''

## Related Projects
- [Nextcloud](https://nextcloud.com)
- [Docker](https://www.docker.com)
- [Alpine Linux](https://www.alpinelinux.org)
