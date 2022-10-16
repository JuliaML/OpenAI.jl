@testset "completion" begin
  r = list_models(ENV["OPENAI_API_KEY"])
  if !=(r.status, 200)
    @test false
  end
  r = create_completion(
    ENV["OPENAI_API_KEY"], 
    r.response["data"][begin]["id"];
    prompt = "Say this is a test"
  )
  println(r.response["choices"][begin]["text"])
  if !=(r.status, 200)
    @test false
  end
end