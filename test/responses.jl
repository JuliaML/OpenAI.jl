
@testset "Responses" begin 
    ## Image response tag 
    input = [Dict("role" => "user", 
    "content" => [Dict("type" => "input_text", "text" => "What is in this image?"), 
                 Dict("type" => "input_image", "image_url" => "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg")])
            ]
    resp = create_responses(ENV["OPENAI_API_KEY"], input)
    if !=(resp.status, 200)
        @test false
    end

    ## Web search 
    resp = create_responses(ENV["OPENAI_API_KEY"], "What was a positive news story from today?"; tools=[Dict("type" => "web_search_preview")])
    if !=(resp.status, 200)
        @test false
    end

    ## Streaming 
    resp = create_responses(ENV["OPENAI_API_KEY"], "Hello!"; instructions="You are a helpful assistant.", stream=true, streamcallback = x->println(x))
    if !=(resp.status, 200)
        @test false
    end

    ## Functions 
    tools = [
        Dict(
            "type" => "function",
            "name" => "get_current_weather",
            "description" => "Get the current weather in a given location",
            "parameters" => Dict(
            "type" => "object",
            "properties" => Dict(
                "location" => Dict(
                    "type" => "string",
                    "description" => "The city and state, e.g. San Francisco, CA",
                ),
                "unit"=> Dict("type" => "string", "enum" => ["celsius", "fahrenheit"]),
            ),
            "required" => ["location", "unit"],
            )
        )
    ]
    resp = create_responses(ENV["OPENAI_API_KEY"], "What is the weather in Boston?"; tools=tools, tool_choice="auto")
    if !=(resp.status, 200)
        @test false
    end

    ## Reasoning 

    resp = create_responses(ENV["OPENAI_API_KEY"], "How much wood would a woodchuck chuck?";
    model = "o3-mini",
    reasoning=Dict("effort" => "high"))
    if !=(resp.status, 200)
        @test false
    end


end