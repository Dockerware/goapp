FROM openjdk:15

RUN echo ${OSTYPE}

LABEL maintainer="DockerWare.github.io" \
	  openjdk.version="15" \
	  gradle.version="6.3" \
	  android.ndk.version="21.1.6352462" \
	  android.sdk.tools.version="6200805" \
	  go.version="1.14.2"
