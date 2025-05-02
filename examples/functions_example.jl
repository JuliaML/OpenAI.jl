## Example of using Functions for Julia 


## Functions 
tools = [
    Dict(
        "type" => "function",
        "name" => "get_avg_temperature",
        "description" => "Get average temperature in a given location",
        "parameters" => Dict(
        "type" => "object",
        "properties" => Dict(
            "location" => Dict(
                "type" => "string",
                "description" => "The city with no spaces, e.g. SanFrancisco",
            )
        ),
        "required" => ["location"],
        )
    )
]
resp = create_responses(ENV["OPENAI_API_KEY"], "What is the avg temp in New York?"; tools=tools, tool_choice="auto")

resp.response.output