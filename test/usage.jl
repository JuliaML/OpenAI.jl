# Get usage status of an api

# See https://github.com/JuliaML/OpenAI.jl/issues/46
@testset "usage information" begin
    provider = OpenAI.OpenAIProvider(ENV["OPENAI_API_KEY"], "https://api.openai.com/v1", "")
    (; quota, usage, daily_costs) = get_usage_status(provider, numofdays=5)
    @test quota > 0
    @test usage >= 0
    @test length(daily_costs) == 5
    println("Total quota: $quota")
    println("Total usage: $usage")
    costs = [sum(item["cost"] for item in day.line_items) for day in daily_costs]
    println("Recent costs(5 days): $costs")
end