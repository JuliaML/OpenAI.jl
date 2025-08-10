using Test
using HTTP
using Sockets
using OpenAI

@testset "StreamCallbacks integration" begin
    port = 9178
    handler(req) = HTTP.Response(200,
        ["Content-Type" => "text/event-stream"],
        "data: {\"choices\": [{\"delta\": {\"content\": \"hello\"}}]}\n\n" *
        "data: [DONE]\n\n")
    server = HTTP.serve!(handler, Sockets.localhost, port; verbose = false)
    try
        provider = OpenAI.OpenAIProvider(api_key = "key", base_url = "http://127.0.0.1:$port")

        io = IOBuffer()
        resp = OpenAI.create_chat(provider, "model",
            [Dict("role" => "user", "content" => "hi")];
            streamcallback = io)
        seekstart(io)
        @test occursin("hello", String(take!(io)))
        @test resp.status == 200

        buf = IOBuffer()
        cbfunc = text -> write(buf, text)
        resp2 = OpenAI.create_chat(provider, "model",
            [Dict("role" => "user", "content" => "hi")];
            streamcallback = cbfunc)
        seekstart(buf)
        @test occursin("hello", String(take!(buf)))
        @test resp2.status == 200
    finally
        HTTP.forceclose(server)
    end
end
