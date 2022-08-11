@testset "completion" begin
  api_key = "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"
  r = list_models(api_key)
  if !=(r.status, 200)
    @test false
  end
  r = create_completion(
    api_key, 
    r.response["data"][begin]["id"];
    prompt = "Say this is a test"
  )
  println(r.response["choices"][begin]["text"])
  if !=(r.status, 200)
    @test false
  end
end