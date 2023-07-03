@testset "completion" begin
  r = list_models(ENV["OPENAI_API_KEY"])
  if !=(r.status, 200)
    @test false
  end  
  r = create_completion(
    ENV["OPENAI_API_KEY"],
    "text-ada-001";
    prompt="Say \"this is a test\""
  )
  println(r.response["choices"][begin]["text"])
  if !=(r.status, 200)
    @test false
  end  
end

@testset "create edit" begin
  r = create_edit(
    ENV["OPENAI_API_KEY"],
    "text-davinci-edit-001",
    "Fix this piece of text for grammatical errors",
    input="I hav ben riting sence i wuz 5"
  )
  println(r.response["choices"][begin]["text"])
  if !=(r.status, 200)
    @test false
  end
end