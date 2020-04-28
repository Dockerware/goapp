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

.PHONY: say
say:
	@echo $(ANDROID_SDK_TOOLS_FILENAME)
	@echo $(shell < checksum.txt grep ${ANDROID_SDK_TOOLS_FILENAME} | cut -f1)

.PHONY: rebuild
rebuild: clean build

.PHONY: build
build: Dockerfile
	docker build \
		--force-rm \
		--tag $(REPO) \
		--tag $(REPO):$(TAG) .

.PHONY: push
push: build
	docker push $(REPO):$(TAG)

.PHONY: clean
clean:
	rm -f Dockerfile $(DOCKERFILE)

Dockerfile: $(DOCKERFILE)
	@rm -f Dockerfile
	ln -s $(DOCKERFILE) $(@)

$(DOCKERFILE): Dockerfile.test
	m4 \
		-DOPENJDK_VERSION=$(OPENJDK_VERSION) \
		-DGO_VERSION=$(GO_VERSION) \
		-DGO_CHECKSUM=$(shell < checksum.txt grep ${GO_FILENAME} | cut -f1) \
		-DGO_FILENAME=$(GO_FILENAME) \
		-DGOMOBILE_VERSION=$(GOMOBILE_VERSION) \
		-DGRADLE_VERSION=$(GRADLE_VERSION) \
		-DGRADLE_CHECKSUM=$(shell < checksum.txt grep ${GRADLE_FILENAME} | cut -f1) \
		-DGRADLE_FILENAME=$(GRADLE_FILENAME) \
		-DANDROID_SDK_TOOLS_VERSION=$(ANDROID_SDK_TOOLS_VERSION) \
		-DANDROID_SDK_TOOLS_CHECKSUM=$(shell < checksum.txt grep ${ANDROID_SDK_TOOLS_FILENAME} | cut -f1) \
		-DANDROID_SDK_TOOLS_FILENAME=$(ANDROID_SDK_TOOLS_FILENAME) \
		-DANDROID_COMPILE_SDK_VERSION=$(ANDROID_COMPILE_SDK_VERSION) \
		-DANDROID_BUILD_TOOLS_VERSION=$(ANDROID_BUILD_TOOLS_VERSION) \
		-DANDROID_NDK_VERSION=$(ANDROID_NDK_VERSION) \
		Dockerfile.test > $(@)
