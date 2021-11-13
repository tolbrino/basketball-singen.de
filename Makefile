.POSIX:

ifeq ($(OS),Windows_NT)
HUGO_OS := Windows
else
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
HUGO_OS := Linux
endif
ifeq ($(UNAME_S),Darwin)
HUGO_OS := macOS
endif
ifeq ($(UNAME_S),FreeBSD)
HUGO_OS := FreeBSD
endif
endif

HUGO_VERSION ?= 0.89.2
HUGO_ARCH ?= 64bit
HUGO_PLATFORM ?= ${HUGO_OS}-${HUGO_ARCH}

all: install build

.PHONY: yarn
yarn: ## install JS dependencies with yarn
	yarn install --pure-lockfile

.PHONY: install
install: yarn .bin/hugo

.PHONY: build
build: ## build site with hugo
	.bin/hugo

.bin/hugo:
	curl -Ls https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${HUGO_PLATFORM}.tar.gz -o /tmp/hugo.tar.gz
	curl -Ls https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_checksums.txt -o /tmp/hugo_checksums.txt
	grep "${HUGO_PLATFORM}.tar.gz" /tmp/hugo_checksums.txt | awk '{ print $$1," /tmp/hugo.tar.gz";}' | openssl sha256
	tar xf /tmp/hugo.tar.gz -C /tmp
	mkdir -p .bin
	mv /tmp/hugo .bin/hugo
	rm /tmp/hugo.tar.gz /tmp/hugo_checksums.txt

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
