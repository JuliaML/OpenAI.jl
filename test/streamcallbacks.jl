using Test
using HTTP
using Sockets
using OpenAI
using StreamCallbacks

@testset "StreamCallbacks integration" begin
    port = 9178
    handler(req) = HTTP.Response(200,
        ["Content-Type" => "text/event-stream"],
        "data: {\"choices\": [{\"delta\": {\"content\": \"hello\"}}]}\n\n" *
        "data: [DONE]\n\n")
    server = HTTP.serve!(handler, Sockets.localhost, port; verbose = false)
    try
        io = IOBuffer()
        provider = OpenAI.OpenAIProvider(base_url = "http://127.0.0.1:$port")
        resp = OpenAI.create_chat(nothing, "key", "model",
            [Dict("role" => "user", "content" => "hi")];
            provider = provider,
            streamcallback = io)
        seekstart(io)
        @test occursin("hello", String(take!(io)))
        @test resp.status == 200
    finally
        HTTP.forceclose(server)
    end
end
