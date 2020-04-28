FROM openjdk:15

RUN set -o errexit -o nounset && echo "OSTYPE:${OSTYPE}"

LABEL maintainer="DockerWare.github.io"
