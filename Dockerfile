FROM golang:1.12-alpine as builder

# For compressing binary
RUN set -euo pipefail && \
    wget https://github.com/upx/upx/releases/download/v3.95/upx-3.95-amd64_linux.tar.xz; \
    tar xvf upx-3.95-amd64_linux.tar.xz; \
    mv upx-3.95-amd64_linux/upx /usr/local/bin/; \
    rm -r upx-3.95-amd64_linux upx-3.95-amd64_linux.tar.xz; \
    :

# For interpolating Jinja2-like template
RUN set -euo pipefail && \
    wget https://github.com/guangie88/tera-cli/releases/download/v0.1.1/tera_linux_amd64; \
    chmod +x tera_linux_amd64; \
    mv tera_linux_amd64 /usr/local/bin/tera; \
    :

# Install basic building dependencies
RUN apk add --no-cache gcc git musl-dev

WORKDIR /workdir
COPY ./build.sh ./plugins.yml /workdir/

ARG REPO_GIT_URL=https://github.com/mholt/caddy.git
ARG REPO_REV=v1.0.0
ARG PLUGINS=

# Build the binary
RUN ./build.sh "${REPO_GIT_URL}" "${REPO_REV}" "${PLUGINS}"

# Compress the binary
RUN upx --best caddy

FROM alpine:3.9 as release
RUN apk add --no-cache ca-certificates
COPY --from=builder /workdir/caddy /usr/local/bin/
COPY ./run.sh ./

CMD ["./run.sh"]
