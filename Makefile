.SUFFIXES:
.PHONY: all
all: build push

REPO ?= docker.pkg.github.com/dockerware/goapp/test

PLATFORM ?= linux
ARCH ?= amd64

OPENJDK_VERSION ?= 15

GO_VERSION ?= 1.14.2
GO_FILENAME ?= go$(GO_VERSION).$(PLATFORM)-$(ARCH).tar.gz

GRADLE_VERSION ?= 6.3
GRADLE_FILENAME ?= gradle-$(GRADLE_VERSION)-bin.zip

ANDROID_SDK_TOOLS_VERSION ?= 6200805
ANDROID_SDK_TOOLS_FILENAME ?= commandlinetools-$(PLATFORM)-$(ANDROID_SDK_TOOLS_VERSION)_latest.zip

ANDROID_COMPILE_SDK_VERSION ?= 29
ANDROID_BUILD_TOOLS_VERSION ?= 29.0.3
ANDROID_NDK_VERSION ?= 21.1.6352462 # r21b

TAG ?= $(GO_VERSION)-$(ANDROID_NDK_VERSION)
DOCKERFILE = Dockerfile.$(PLATFORM)-$(TAG)


build: Dockerfile
	docker build \
		--tag $(REPO) \
		.

push: build
	docker push $(REPO)
