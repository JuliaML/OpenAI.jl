@testset "chatcompletion" begin
    r = create_chat(
        ENV["OPENAI_API_KEY"],
        "gpt-3.5-turbo",
        [Dict("role" => "user", "content" => "What is the OpenAI mission?")],
    )
    println(r.response["choices"][begin]["message"]["content"])
    if !=(r.status, 200)
        @test false
    end

    # with http kwargs (with default values)
    r = create_chat(
        ENV["OPENAI_API_KEY"],
        "gpt-3.5-turbo",
        [
            Dict(
                "role" => "user",
                "content" => "Summarize HTTP.jl package in a short sentence.",
            ),
        ],
        http_kwargs = (connect_timeout = 10, readtimeout = 0),
    )
    println(r.response["choices"][begin]["message"]["content"])
    if !=(r.status, 200)
        @test false
    end
end

@testset "chatcompletion - streaming" begin

    r = create_chat(
        ENV["OPENAI_API_KEY"],
        "gpt-3.5-turbo",
        [
            Dict(
                "role" => "user",
                "content" => "What continent is New York in? Two word answer.",
            ),
        ],
        streamcallback = let
            count = 0

            function f(s::String)
                count = count + 1
                println("Chunk $count")
            end
        end,
    )

    println(map(r -> r["choices"][1]["delta"], r.response))
    if !=(r.status, 200)
        @test false
    end
end
