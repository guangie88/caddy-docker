#!/usr/bin/env sh
set -euo pipefail

readonly REPO_GIT_URL=$1
readonly REPO_REV=$2
readonly PLUGINS=$3

readonly CADDY_MAIN_DIR=caddy/caddy

git clone ${REPO_GIT_URL} -b ${REPO_REV}
cd ${CADDY_MAIN_DIR}

MAIN_SRC=$(cat <<EOM
package main

import (
	"github.com/mholt/caddy/caddy/caddymain"
	// _ "import/path/here"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
EOM
)

printf "%s\n" "${MAIN_SRC}" > main.go
go install -v

# Shift the built binary out back at original dir and clean up
cd -
rm -rf caddy
mv ${GOPATH}/bin/caddy ./
rm -rf ${GOPATH}/bin/* ${GOPATH}/pkg/* ${GOPATH}/src/*
