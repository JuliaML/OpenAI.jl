module OpenAI

using HTTP
using JSON

const BASE_URL_v1="https://api.openai.com/v1"

struct OpenAIResponse
  status
  response
end

"""
List models

https://beta.openai.com/docs/api-reference/models/list

# Arguments:
- `api_key::String`: OpenAI API key
"""
function list_models(api_key::String)
  url = BASE_URL_v1*"/models"
  request_headers = Dict(
    "Authorization" => "Bearer "*api_key,
    "Content-Type" => "application/json",
  )
  response = HTTP.request(
    "GET",
    url,
    request_headers;
    retry = false
  )
  return OpenAIResponse(response.status, JSON.parse(String(response.body)))
end

"""
Retrieve model

https://beta.openai.com/docs/api-reference/models/retrieve

# Arguments:
- `api_key::String`: OpenAI API key
- `model_id::String`: Model id
"""
function retrieve_model(api_key::String, model_id::String)
  url = BASE_URL_v1*"/models/"*model_id
  request_headers = Dict(
    "Authorization" => "Bearer "*api_key,
    "Content-Type" => "application/json",
  )
  response = HTTP.request(
    "GET",
    url,
    request_headers;
    retry = false
  )
  return OpenAIResponse(response.status, JSON.parse(String(response.body)))
end

"""
Create completion

https://beta.openai.com/docs/api-reference/completions

# Arguments:
- `api_key::String`: OpenAI API key
- `model_id::String`: Model id
"""
function create_completion(api_key::String, model_id::String; kwargs...)
  url = BASE_URL_v1*"/completions"
  request_headers = Dict(
    "Authorization" => "Bearer "*api_key,
    "Content-Type" => "application/json",
  )
  params = Dict(kwargs)
  params[:model] = model_id
  response = HTTP.request(
    "POST",
    url,
    request_headers,
    JSON.json(params);
    retry = false
  )
  return OpenAIResponse(response.status, JSON.parse(String(response.body)))
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
  url = BASE_URL_v1*"/edits"
  request_headers = Dict(
    "Authorization" => "Bearer "*api_key,
    "Content-Type" => "application/json",
  )
  params = Dict(kwargs)
  params[:model] = model_id          # Set the model param
  params[:instruction] = instruction # Set the instruction param
  response = HTTP.request(
    "POST",
    url,
    request_headers,
    JSON.json(params);
    retry = false
  )
  return OpenAIResponse(response.status, JSON.parse(String(response.body)))
end

export OpenAIResponse
export list_models
export retrieve_model
export create_completion
export create_edit

end # module
