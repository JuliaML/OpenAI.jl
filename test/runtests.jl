using OpenAI
using Test

@testset "OpenAI.jl" begin
  printstyled(color=:blue, "\n")
  @testset "models" begin
    include("models.jl")
  end
  @testset "completion" begin
    include("completion.jl")
  end
end
