FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gcc-riscv64-unknown-elf \
        binutils-riscv64-unknown-elf \
        make \
        python3 \
        git \
        time \
    && rm -rf /var/lib/apt/lists/*

ENV COMP311_ARCH=rv32i
ENV COMP311_ABI=ilp32

WORKDIR /workspaces
