### 0.10.0

* Removed deprecated features `create_edit` and `get_usage_statistics`

### 0.9.1

* Fixed a bug in `request_body` that prevented `query` argument from being passed to `HTTP.jl`.
* Updated completion model in the unit tests suite (`ada` series has been deprecated).
* Added warnings to `create_edit` that it's deprecated by OpenAI. Disabled tests for `get_usage_status` and `create_edit` functions, as they cannot be tested via API.

### 0.9.0

* Added OpenAI Assistants API

### 0.8.7

* disable `test/usage.jl` in `test/runtests.jl` to close issue: https://github.com/JuliaML/OpenAI.jl/issues/46

### 0.8.6

#### Pull Requests: 

* https://github.com/JuliaML/OpenAI.jl/pull/49

#### Notes:

* bugfix: http_kwargs (ie, kwargs to be provided to HTTP.jl requests) are not being passed, because of a missing semicolon inside of request_body() call.

### 0.8.5

#### Pull Requests: 

* https://github.com/JuliaML/OpenAI.jl/pull/40

#### Notes:

* bugfix: created a separate test file for chat completion: despite the naming similarity, 
          the /v1/chat/completions has nothing to do with /v1/completions. 
          If a test fails, we need to be able to differentiate between the two easily.
* added JET code quality test
* add attributions for contributors via authors field in Project.toml

### 0.8.4

* feature: get api usage via get_usage_status(), add test
* refactor: rewrite methods related to api

### 0.8.3

* bugfix: issue with HTTP.request kwargs propagation, 
          enables the user to pass an arbitrarily named tuple to http_kwargs

### 0.8.2

* bugfix: error in chat streaming
* Refactor to remove Downloads.jl in favor of HTTP.jl

### 0.8.1

* feature: add chat streaming

### 0.8.0

* feature: introduce provider abstraction to support arbitrary OpenAI deployments

### 0.7.0

* feature: add image generation endpoint
* add create_edit example
* update README

### 0.6.0

* feature: add API for creating embeddings
* feature: add chat/completion

### 0.5.1

* bugfix: avoid issues with quoted strings in kwargs

### 0.5.0

* Replace HTTP/JSON with Downloads/JSON3

### 0.4.1

* removed Manifest.toml from tracking
* updated HTTP compat

### 0.4.0

* feature: added "create edit"

### 0.3.1

* added GitHub Actions workflow for running tests and parameterizing secrets

### 0.3.0

* adding completions

### 0.2.0

* engine endpoints deprecated in favor of models

### 0.1.0

* engine endpoints working
