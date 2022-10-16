@testset "models" begin
  r = list_models(ENV["OPENAI_API_KEY"])
  println(r)
  if !=(r.status, 200)
    @test false
  end
  r = retrieve_model(ENV["OPENAI_API_KEY"], r.response["data"][begin]["id"])
  println(r)
  if !=(r.status, 200)
    @test false
  end
end