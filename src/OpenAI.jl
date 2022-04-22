module OpenAI

using HTTP

struct OpenAIResponse
  status
  response
end

export OpenAIResponse

end # module
