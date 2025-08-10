@testset "chatcompletion" begin
    r = create_chat(ENV["OPENAI_API_KEY"],
        "gpt-5-mini",
        [Dict("role" => "user", "content" => "What is the OpenAI mission?")])
    println(r.response["choices"][begin]["message"]["content"])
    if !=(r.status, 200)
        @test false
    end

    # with http kwargs (with default values)
    r = create_chat(ENV["OPENAI_API_KEY"],
        "gpt-5-mini",
        [
            Dict("role" => "user",
            "content" => "Summarize HTTP.jl package in a short sentence.")
        ],
        http_kwargs = (connect_timeout = 10, readtimeout = 0))
    println(r.response["choices"][begin]["message"]["content"])
    if !=(r.status, 200)
        @test false
    end
end

@testset "chatcompletion - streaming" begin
    cb = StreamCallback()
    r = create_chat(ENV["OPENAI_API_KEY"],
        "gpt-5-mini",
        [
            Dict("role" => "user",
            "content" => "What continent is New York in? Two word answer.")
        ];
        streamcallback = cb)

    println("Received $(length(cb.chunks)) chunks")
    if !=(r.status, 200)
        @test false
    end
end
