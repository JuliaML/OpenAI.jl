@testset "images" begin
    r = create_images(ENV["OPENAI_API_KEY"], "Create a pixelated cow", 1, "256x256")

    println(r.response["data"][begin]["url"])
  if !=(r.status, 200)
    @test false
  end
end