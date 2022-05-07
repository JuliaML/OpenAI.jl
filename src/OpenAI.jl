module OpenAI

using HTTP
using JSON

const BASE_URL_v1="https://api.openai.com/v1"

struct OpenAIResponse
  status
  response
end

"""
List engines

https://beta.openai.com/docs/api-reference/engines/list

# Arguments:
- `api_key::String`: OpenAI API key
"""
function list_engines(api_key::String)
  url = BASE_URL_v1*"/engines"
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
Retrieve engine

https://beta.openai.com/docs/api-reference/engines/retrieve

# Arguments:
- `api_key::String`: OpenAI API key
- `engine_id::String`: Engine id
"""
function retrieve_engine(api_key::String, engine_id::String)
  url = BASE_URL_v1*"/engines/"*engine_id
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
export list_engines
export retrieve_engine

end # module
