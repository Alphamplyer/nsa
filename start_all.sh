#!/bin/bash
build_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
vagrant destroy -f
vagrant up
${build_dir}/upload_keys_on_server.sh
${build_dir}/create_repository.sh