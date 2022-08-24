SEVERITIES = HIGH,CRITICAL

ifeq ($(ARCH),)
ARCH=$(shell go env GOARCH)
endif

BUILD_META=-build$(shell TZ=UTC date +%Y%m%d)
ORG ?= rancher
PKG ?= github.com/kubernetes-sigs/cri-tools
SRC ?= github.com/kubernetes-sigs/cri-tools
TAG ?= v1.23.0$(BUILD_META)

ifneq ($(DRONE_TAG),)
TAG := $(DRONE_TAG)
endif

ifeq (,$(filter %$(BUILD_META),$(TAG)))
$(error TAG needs to end with build metadata: $(BUILD_META))
endif

GOLANG_VERSION := $(shell ./scripts/golang-version.sh $(TAG))
CREATED ?= $(shell date --iso-8601=s -u)
REF ?= $(shell git symbolic-ref HEAD)
## --label "org.opencontainers.image.url=https://github.com/rancher/image-build-cri" \
## --label "org.opencontainers.image.created=$(CREATED)" \
## --label "org.opencontainers.image.authors=brooksn" \
## --label "org.opencontainers.image.ref.name=$(REF)" \
## --target builder \
##
##
.PHONY: image-build
image-build:
	docker build \
		--build-arg PKG=$(PKG) \
		--build-arg SRC=$(SRC) \
		--build-arg TAG=$(TAG:$(BUILD_META)=) \
 		--build-arg ARCH=$(ARCH) \
 		--build-arg GO_IMAGE=rancher/hardened-build-base:$(GOLANG_VERSION) \
		--tag $(ORG)/hardened-crictl:$(TAG) \
		--tag $(ORG)/hardened-crictl:$(TAG)-$(ARCH) \
		--label "org.opencontainers.image.url=https://github.com/brooksn/image-build-crictl" \
		--label "org.opencontainers.image.created=$(CREATED)" \
		--label "org.opencontainers.image.authors=brooksn" \
		--label "org.opencontainers.image.ref.name=$(REF)" \
	.

.PHONY: image-push
image-push:
	docker push $(ORG)/hardened-crictl:$(TAG)-$(ARCH)

.PHONY: image-manifest
image-manifest:
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend \
		$(ORG)/hardened-crictl:$(TAG) \
		$(ORG)/hardened-crictl:$(TAG)-$(ARCH)
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push \
		$(ORG)/hardened-crictl:$(TAG)

.PHONY: image-scan
image-scan:
	trivy --severity $(SEVERITIES) --no-progress --ignore-unfixed $(ORG)/hardened-crictl:$(TAG)
