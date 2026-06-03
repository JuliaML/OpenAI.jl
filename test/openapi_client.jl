@testset "generated OpenAPI client" begin
    client = openai_client("test-key")

    @test OpenAIClient.API_VERSION == "2.3.0"
    @test client.root == "https://api.openai.com/v1"
    @test client.headers["Authorization"] == "Bearer test-key"
    @test !haskey(client.headers, "Content-Type")

    models_api = OpenAIClient.ModelsApi(client)
    @test models_api isa OpenAIClient.ModelsApi
    @test OpenAIClient.basepath(OpenAIClient.ModelsApi) == "https://api.openai.com/v1"
end
