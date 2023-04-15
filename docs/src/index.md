# OpenAI.jl Documentation

```@docs
list_models(api_key::String; http_kwargs::NamedTuple=NamedTuple())
```

```@docs
retrieve_model(api_key::String, model_id::String; http_kwargs::NamedTuple=NamedTuple())
```

```@docs
create_completion(api_key::String, model_id::String; http_kwargs::NamedTuple=NamedTuple(), kwargs...)
```

```@docs
create_chat
```

```@docs
create_edit(api_key::String, model_id::String, instruction::String; http_kwargs::NamedTuple=NamedTuple(), kwargs...)
```

```@docs
create_embeddings(api_key::String, input, model_id::String=DEFAULT_EMBEDDING_MODEL_ID; http_kwargs::NamedTuple=NamedTuple(), kwargs...)
```

```@docs
create_images(api_key::String, prompt, n::Integer=1, size::String="256x256"; http_kwargs::NamedTuple=NamedTuple(), kwargs...)
```