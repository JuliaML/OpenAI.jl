# AGENTS.md

Guidance for AI agents working on this repository.

## Project Overview

This repository is `OpenAI.jl`, an unofficial Julia wrapper for the OpenAI API.
It currently has two API layers:

- A handwritten convenience wrapper in `src/OpenAI.jl` and `src/assistants.jl`.
- A generated OpenAPI client under `src/generated/`, exposed as
  `OpenAI.OpenAIClient`.

The handwritten wrapper is still the stable, ergonomic package API. Do not
remove or rewrite it just because the generated client covers overlapping
endpoints. Existing users call functions such as `create_chat`,
`create_embeddings`, `create_completion`, `create_responses`, `list_models`,
and `retrieve_model`.

The generated client is the broad low-level API surface. It provides typed
models and API groups generated from the OpenAI OpenAPI specification snapshot
in `openapi/openapi.yaml`.

## Repository Layout

- `Project.toml`: package metadata, dependencies, compat bounds, and test
  targets. The package currently requires Julia `1.9` or newer because
  `StreamCallbacks 0.6.x` requires Julia `1.9+`.
- `src/OpenAI.jl`: main module, providers, auth, request helpers, handwritten
  endpoint wrappers, streaming callback integration, generated client include,
  and exports.
- `src/assistants.jl`: handwritten Assistants/Threads/Messages/Runs helpers.
  Some assistant exports are intentionally disabled in `src/OpenAI.jl`.
- `src/generated/`: generated Julia OpenAPI client source. Treat this as
  generated code.
- `openapi/openapi.yaml`: committed snapshot of the upstream OpenAI OpenAPI
  specification used to generate `src/generated/`.
- `scripts/generate_openapi_client.sh`: reproducible generation script using
  the Docker image `openapitools/openapi-generator-cli`.
- `test/`: live and smoke tests. Most tests expect `OPENAI_API_KEY`.
- `docs/`: Documenter.jl source and build script.
- `.gitattributes`: marks `src/generated/**` as generated for GitHub/Linguist.
- `.gitignore`: ignores `Manifest.toml`, editor files, `.env`, and
  `docs/build/`.

## Dependencies And Compatibility

Runtime dependencies are declared in `Project.toml`.

Important current dependencies:

- `HTTP`: handwritten HTTP request layer.
- `JSON3`: handwritten request/response JSON handling.
- `StreamCallbacks`: streaming support for handwritten APIs.
- `OpenAPI` and `TimeZones`: required by generated OpenAPI client code.

Do not add a dependency only for convenience. If a new dependency is required,
add it to `[deps]`, add a conservative `[compat]` entry, and verify docs/tests
still resolve on the supported Julia version.

`Manifest.toml` is ignored and should not be committed for this package unless
the project policy changes explicitly.

## Handwritten API Layer

The handwritten request path is centered on:

- `OpenAIProvider` and `AzureProvider`.
- `auth_header`.
- `build_url`.
- `build_params`.
- `_request` and `openai_request`.
- `OpenAIResponse`.

The handwritten wrappers accept loose Julia-native inputs such as `Dict`,
vectors, strings, and keyword arguments. They return `OpenAIResponse(status,
response)` where `response` is parsed with `JSON3.read`.

Streaming is integrated through `StreamCallbacks`:

- Public callers should pass `streamcallback=...` rather than manually setting
  `stream=true` for `create_chat`.
- `configure_callback!` sets `stream=true` and
  `stream_options=(include_usage=true,)`.

When modifying handwritten API behavior, preserve existing call signatures
unless intentionally making a breaking change. Update README/docs/tests for any
public behavior change.

## Generated OpenAPI Client

The generated client lives in `src/generated/` and is included by
`src/OpenAI.jl`:

```julia
include("generated/OpenAIClient.jl")
```

The generated module is exported as `OpenAIClient`, and the helper
`openai_client(...)` creates an authenticated `OpenAPI.Clients.Client`.

Typical generated-client usage:

```julia
using OpenAI

client = openai_client(ENV["OPENAI_API_KEY"])
models_api = OpenAIClient.ModelsApi(client)
models, http_response = OpenAIClient.list_models(models_api)
```

Generated files should usually be changed by regenerating from
`openapi/openapi.yaml`, not by manual edits. If a generated file must be patched
by hand as a temporary unblocker, document why in the PR and prefer following up
with a generator/spec/template fix.

To regenerate:

```bash
scripts/generate_openapi_client.sh
```

The script:

- Requires Docker.
- Uses `openapitools/openapi-generator-cli` unless
  `OPENAPI_GENERATOR_IMAGE` is set.
- Generates Julia client source with `julia-client`.
- Suppresses generated Markdown docs with
  `--global-property apiDocs=false,modelDocs=false`.
- Replaces `src/generated/`.

The generator may emit warnings for OpenAPI 3.1 support, inline schemas,
free-form objects, aliases, multipart form models, or unknown formats such as
`unixtime`. Those warnings are not automatically failures. Always verify that
the package loads and the generated smoke test passes after regeneration.

## What To Commit

Commit these when they change intentionally:

- `openapi/openapi.yaml`
- `scripts/generate_openapi_client.sh`
- `src/generated/**`
- `.gitattributes`
- README/docs/tests that explain or exercise generated APIs

Do not commit these unless project policy changes:

- `Manifest.toml`
- `docs/build/`
- `.openapi-generator/`
- `.openapi-generator-ignore`
- temporary generator output directories
- `.env` or files containing API keys

## Tests

The test suite is live-API oriented and expects `OPENAI_API_KEY` for most
tests. The main command is:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

Current test structure:

- `test/openapi_client.jl`: generated-client construction smoke test plus live
  `OpenAIClient.list_models` call.
- `test/models.jl`: handwritten model list/retrieve calls.
- `test/chatcompletion.jl`: handwritten chat completion and streaming checks.
- `test/completion.jl`: handwritten completions.
- `test/embeddings.jl`: handwritten embeddings.
- `test/streamcallbacks.jl`: local callback/server behavior.
- `test/responses.jl`: currently present but not included in `runtests.jl`.
- `test/assistants.jl`: currently present but not included in `runtests.jl`.

If you add a new public feature, add the narrowest useful test. For generated
client changes, prefer one or two smoke tests over broad tests of generated
output.

If live API tests fail, distinguish between code regressions, missing/invalid
`OPENAI_API_KEY`, model availability, network issues, and API behavior changes.

## Documentation

Docs are built with Documenter.jl:

```bash
julia --project=docs/ docs/make.jl
```

The docs workflow develops this package into a docs environment. Keep the docs
Julia version compatible with `Project.toml`. The docs workflow should not be
older than the package's `[compat] julia` lower bound.

`docs/build/` is generated output and should remain untracked.

When adding public API, add docs if users need to discover it. For small helper
functions, a docstring plus a short docs page entry may be enough.

## CI And Formatting

The main CI workflow runs package tests and JuliaFormatter. Run the formatter
locally before pushing handwritten changes:

```bash
julia -e 'import Pkg; Pkg.activate(; temp=true); Pkg.add("JuliaFormatter"); using JuliaFormatter; format(".", verbose=true)'
```

`.JuliaFormatter.toml` ignores `src/generated` and `docs/build`. Do not format
generated OpenAPI output unless you are intentionally changing generation
policy. If formatting policy changes for generated code, update this file and
CI together.

There is a commented JET test block in `test/runtests.jl`. Do not assume JET is
active unless you re-enable and verify it.

## Versioning

The package version is in `Project.toml`.

For strict SemVer-style handling in the current `0.x` series:

- Patch bump for bug fixes that do not add API.
- Minor bump for new public capabilities or compatibility changes.
- Avoid `1.0.0` unless maintainers intentionally declare the API stable.

Adding the generated `OpenAIClient` and `openai_client` helper is a public
capability and belongs in a minor bump from `0.12.0` to `0.13.0`.

## Common Pitfalls

- Do not delete the handwritten wrapper layer just because generated endpoints
  exist. The handwritten API is the compatibility layer users already depend on.
- Do not commit generated Markdown docs from OpenAPI Generator unless the
  project intentionally decides to publish them.
- Do not rely on Julia `1.8` in CI while `StreamCallbacks = "0.6"` is required.
- Do not add `Content-Type` as a default generated-client header. Generated
  OpenAPI calls set content type per request. `openai_client` intentionally
  keeps auth headers and skips the handwritten layer's default content type.
- Be careful with `AzureProvider`: the handwritten wrapper has Azure-specific
  URL and auth behavior. The generated client helper currently uses
  `provider.base_url` and auth headers; it does not automatically reproduce all
  Azure query-version behavior.

## Required AGENTS.md Maintenance

Agents must keep this file current.

Before finishing any change, check whether `AGENTS.md` became stale. Update it
in the same change if you:

- Add, remove, rename, or substantially change public APIs.
- Change provider/auth/request behavior.
- Change streaming behavior.
- Change generated-client layout, generation commands, committed spec policy,
  or generated-file review policy.
- Add or remove dependencies, compat bounds, supported Julia versions, or CI
  versions.
- Add, remove, or reorganize tests.
- Change docs build behavior or docs workflow versions.
- Add new scripts, tooling, release/versioning conventions, or operational
  workflows.
- Discover a recurring pitfall that future agents should avoid.

When adding a new feature, add a short note here describing where it lives, how
to test it, and any non-obvious constraints. When changing an existing feature,
update or remove outdated guidance rather than leaving contradictory text.
