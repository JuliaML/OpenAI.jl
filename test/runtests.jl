using OpenAI
using Test

@testset "OpenAI.jl" begin
  printstyled(color=:blue, "\n")
  @testset "engines" begin
    include("engines.jl")
  end
end
