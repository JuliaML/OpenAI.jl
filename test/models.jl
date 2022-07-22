@testset "models" begin
    api_key = "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"
    r = list_models(api_key)
    println(r)
    if !=(r.status, 200)
      @test false
    end
    r = retrieve_model(api_key, r.response["data"][begin]["id"])
    println(r)
    if !=(r.status, 200)
      @test false
    end
  end