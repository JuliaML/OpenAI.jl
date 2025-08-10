# Streaming examples using StreamCallbacks.jl
using OpenAI

api_key = get(ENV, "OPENAI_API_KEY", "")
model = "gpt-4o-mini"
messages = [Dict("role" => "user", "content" => "Write a short haiku about streams.")]

# 1. Stream to stdout (no differences)
create_chat(api_key, model, messages; streamcallback=stdout)

# 2. Stream with explicit StreamCallback to capture chunks
cb = StreamCallback()
create_chat(api_key, model, messages; streamcallback=cb)
@info "Received $(length(cb.chunks)) chunks"

# 3. Customize printing via `print_content`
import StreamCallbacks: print_content
function print_content(io::IO, content; kwargs...)
    printstyled(io, "🌊 $content"; color=:cyan)
end
cb2 = StreamCallback()
create_chat(api_key, model, messages; streamcallback=cb2)

# 4. Overload `callback` to change chunk handling
import StreamCallbacks: callback, AbstractStreamCallback, AbstractStreamChunk, extract_content
@inline function callback(cb::AbstractStreamCallback, chunk::AbstractStreamChunk; kwargs...)
    processed_text = extract_content(cb.flavor, chunk; kwargs...)
    isnothing(processed_text) && return nothing
    print_content(cb.out, reverse(processed_text); kwargs...)
    return nothing
end
cb3 = StreamCallback()
create_chat(api_key, model, messages; streamcallback=cb3)
