VERSION 0.7
FROM crystallang/crystal:latest
WORKDIR /workdir

all:
    BUILD +format-check
    BUILD +lint
    BUILD +test

deps:
    RUN apt update && apt install -y libnss3
    COPY shard.yml ./
    RUN shards install
    SAVE ARTIFACT shard.lock AS LOCAL ./shard.lock

build:
    FROM +deps
    COPY . .
    SAVE ARTIFACT . .

format-check:
    FROM +build
    RUN crystal tool format --check src spec

test:
    FROM +build
    RUN crystal spec

lint:
    FROM ghcr.io/crystal-ameba/ameba:1.5.0
    COPY . .
    RUN ameba
