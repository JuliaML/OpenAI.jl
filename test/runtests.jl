using OpenAI
using JET
using Pkg
using Test

function get_pkg_version(name::AbstractString)
  for dep in values(Pkg.dependencies())
      if dep.name == name
          return dep.version
      end
  end
  return error("Dependency not available")
end

@testset "Code quality (JET.jl)" begin
  if VERSION >= v"1.9"
      @assert get_pkg_version("JET") >= v"0.8.4"
      JET.test_package(OpenAI; target_defined_modules=true)
  end
end


@testset "OpenAI.jl" begin
  printstyled(color=:blue, "\n")
  @testset "models" begin
    include("models.jl")
  end
  @testset "chatcompletion" begin
    include("chatcompletion.jl")
  end
  @testset "completion" begin
    include("completion.jl")
  end
  @testset "embeddings" begin
    include("embeddings.jl")
  end
  @testset "usage" begin
    include("usage.jl")
  end  
end
