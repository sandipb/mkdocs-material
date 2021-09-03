UPSTREAM_VER := $(shell git describe --tags --abbrev=0)
DOCKER_REPO := sandipb/mkdocs-material
.PHONY: all .check-env build

all: build

.check-env:
	@test -n "$${BUILD_VERSION?Need BUILD_VERSION to be set}"

build: .check-env
	docker build -t $(DOCKER_REPO):$(UPSTREAM_VER)-$(BUILD_VERSION) .

test: .check-env
	dgoss run $(DOCKER_REPO):$(UPSTREAM_VER)-$(BUILD_VERSION)

tag: .check-env test
	docker rmi --force $(DOCKER_REPO):latest
	docker tag $(DOCKER_REPO):$(UPSTREAM_VER)-$(BUILD_VERSION) $(DOCKER_REPO):latest

push: .check-env test
	docker push $(DOCKER_REPO):$(UPSTREAM_VER)-$(BUILD_VERSION)
	docker push $(DOCKER_REPO):latest