@testset "engines" begin
  api_key = "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"
  r = list_engines(api_key)
  println(r)
  if !=(r.status, 200)
    @test false
  end
  r = retrieve_engine(api_key, r.response["data"][begin]["id"])
  println(r)
  if !=(r.status, 200)
    @test false
  end
end