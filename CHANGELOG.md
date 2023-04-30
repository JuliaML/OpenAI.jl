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
