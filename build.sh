#!/usr/bin/env sh
set -euo pipefail

readonly REPO_GIT_URL=$1
readonly REPO_REV=$2
readonly PLUGINS=$3
readonly CADDY_MAIN_DIR=caddy/caddy

git clone "${REPO_GIT_URL}" -b "${REPO_REV}"

# Combine with plugins.yml
cp plugins.yml plugins-labels.yml
echo "labels: ${PLUGINS}" >> plugins-labels.yml

MAIN_SRC=$(cat <<EOM
package main

import (
	"github.com/mholt/caddy/caddy/caddymain"
{%- for label in c.labels | split(pat=",") %}
	_ "{{ c.plugins[label] }}"
{%- endfor %}
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
EOM
)

printf "%s\n" "${MAIN_SRC}" | tera --yaml plugins-labels.yml > ${CADDY_MAIN_DIR}/main.go

# Need to be in caddy dir to 
cd ${CADDY_MAIN_DIR}
go install -v
cd -

# Shift the built binary out back at original dir and clean up
rm -rf caddy
mv ${GOPATH}/bin/caddy ./
rm -rf ${GOPATH}/bin/* ${GOPATH}/pkg/* ${GOPATH}/src/*
