module OpenAI

using Downloads
using JSON3

const BASE_URL_v1 = "https://api.openai.com/v1"

function build_params(kwargs)
    isempty(kwargs) && return nothing
    buf = IOBuffer()
    JSON3.write(buf, kwargs)
    seekstart(buf)
    return buf
end
auth_header(api_key) = ["Authorization" => "Bearer $api_key", "Content-Type" => "application/json"]

function request_body(url; kwargs...)
    resp = nothing
    body = sprint() do output
        resp = request(url; output=output, kwargs...)
    end
    return resp, body
end

function status_error(resp, log=nothing)
    logs = !isnothing(log) ? ": $log" : ""
    error("request status $(resp.message)$logs")
end

function openai_request(api, api_key; method, kwargs...)
    global BASE_URL_v1
    params = build_params(kwargs)
    resp, body = request_body("$(BASE_URL_v1)/$(api)"; method, input = params, headers = auth_header(api_key))
    if resp.status >= 400
        status_error(resp, body)
    else
        return OpenAIResponse(resp.status, JSON3.read(body))
    end
end

struct OpenAIResponse{R}
    status::Int
    response::R
end

"""
List models

https://beta.openai.com/docs/api-reference/models/list

# Arguments:
- `api_key::String`: OpenAI API key
"""
function list_models(api_key::String)
    return openai_request("models", api_key; method = "GET")
end

"""
Retrieve model

https://beta.openai.com/docs/api-reference/models/retrieve

# Arguments:
- `api_key::String`: OpenAI API key
- `model_id::String`: Model id
"""
function retrieve_model(api_key::String, model_id::String)
    return openai_request("models/$(model_id)", api_key; method = "GET")
end

"""
Create completion

https://beta.openai.com/docs/api-reference/completions

# Arguments:
- `api_key::String`: OpenAI API key
- `model_id::String`: Model id
"""
function create_completion(api_key::String, model_id::String; kwargs...)
    return openai_request("completions", api_key; method = "POST", model = model_id, kwargs...)
end

"""
Create edit

https://beta.openai.com/docs/api-reference/edits/create

# Arguments:
- `api_key::String`: OpenAI API key
- `model_id::String`: Model id (e.g. "text-davinci-edit-001")
- `instruction::String`: The instruction that tells the model how to edit the prompt.
- `input::String` (optional): The input text to use as a starting point for the edit.
- `n::Int` (optional): How many edits to generate for the input and instruction.
"""
function create_edit(api_key::String, model_id::String, instruction::String; kwargs...)
    return openai_request("edits", api_key; method = "POST", model = model_id, instruction, kwargs...)
end

export OpenAIResponse
export list_models
export retrieve_model
export create_completion
export create_edit

end # module
