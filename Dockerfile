FROM golang:1.12-alpine as builder

ARG UPX_VERSION=3.95

RUN set -euo pipefail && \
    wget https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-amd64_linux.tar.xz; \
    tar xvf upx-${UPX_VERSION}-amd64_linux.tar.xz; \
    mv upx-${UPX_VERSION}-amd64_linux/upx /usr/local/bin/; \
    rm -r upx-${UPX_VERSION}-amd64_linux upx-${UPX_VERSION}-amd64_linux.tar.xz; \
    :

# Install basic building dependencies
RUN apk add --no-cache gcc git musl-dev

WORKDIR /workdir
COPY ./builder.sh /workdir/

ARG REPO_GIT_URL=https://github.com/mholt/caddy.git
ARG REPO_REV=v1.0.0
ARG PLUGINS=

# Build the binary
RUN ./builder.sh "${REPO_GIT_URL}" "${REPO_REV}" "${PLUGINS}"

# Compress the binary
RUN upx --best caddy

FROM alpine:3.9 as release
RUN apk add --no-cache ca-certificates
COPY --from=builder /workdir/caddy /usr/local/bin/
COPY ./run.sh ./

CMD ["./run.sh"]
