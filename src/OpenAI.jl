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
- `engine_id::String`: Engine id
"""
function retrieve_model(api_key::String, engine_id::String)
  url = BASE_URL_v1*"/models/"*engine_id
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

export OpenAIResponse
export list_models
export retrieve_model

end # module
