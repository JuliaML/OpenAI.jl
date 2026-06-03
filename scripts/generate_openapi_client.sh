#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
spec_path="${1:-"${repo_root}/openapi/openapi.yaml"}"
spec_path="$(realpath "${spec_path}")"
repo_prefix="${repo_root%/}/"

if [[ ! -f "${spec_path}" ]]; then
    echo "OpenAPI spec not found: ${spec_path}" >&2
    exit 1
fi

if [[ "${spec_path}" != "${repo_prefix}"* ]]; then
    echo "OpenAPI spec must live under the repository root for Docker generation." >&2
    exit 1
fi

spec_rel="${spec_path#${repo_prefix}}"
tmpdir="$(mktemp -d)"
cleanup() {
    rm -rf "${tmpdir}"
}
trap cleanup EXIT

generator_image="${OPENAPI_GENERATOR_IMAGE:-openapitools/openapi-generator-cli}"

docker run --rm \
    -v "${repo_root}:/workspace" \
    -v "${tmpdir}:/out" \
    "${generator_image}" generate \
    -g julia-client \
    -i "/workspace/${spec_rel}" \
    -o /out \
    --additional-properties=packageName=OpenAIClient,exportModels=true,exportOperations=true \
    --global-property apiDocs=false,modelDocs=false

rm -rf "${repo_root}/src/generated"
mkdir -p "${repo_root}/src/generated"
cp -a "${tmpdir}/src/." "${repo_root}/src/generated/"
