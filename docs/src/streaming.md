# Streaming

OpenAI.jl integrates [StreamCallbacks.jl](https://github.com/svilupp/StreamCallbacks.jl) for streaming responses.

## 1. Stream to any `IO`
```julia
create_chat(secret_key, model, messages; streamcallback=stdout)
```

## 2. Capture stream chunks
```julia
using StreamCallbacks
cb = StreamCallback()
create_chat(secret_key, model, messages; streamcallback=cb)
cb.chunks
```

## 3. Customize printing
```julia
using StreamCallbacks
import StreamCallbacks: print_content

function print_content(io::IO, content; kwargs...)
    printstyled(io, "🌊 $content"; color=:cyan)
end

cb = StreamCallback()
create_chat(secret_key, model, messages; streamcallback=cb)
```

For complete control you can overload `StreamCallbacks.callback`:
```julia
using StreamCallbacks: callback, AbstractStreamCallback, AbstractStreamChunk, extract_content, print_content

@inline function callback(cb::AbstractStreamCallback, chunk::AbstractStreamChunk; kwargs...)
    processed_text = extract_content(cb.flavor, chunk; kwargs...)
    isnothing(processed_text) && return nothing
    print_content(cb.out, processed_text; kwargs...)
    return nothing
end
```

See the `examples/streamcallbacks.jl` script for a full walkthrough.
