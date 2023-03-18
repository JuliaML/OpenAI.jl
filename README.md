
# OpenAI API wrapper for Julia

## Overview
Provides a Julia wrapper to the OpenAI API.
For API functionality see [reference documentation](https://platform.openai.com/docs/api-reference)

## Usage
```julia
using Pkg; Pkg.add("DataFrames")
```

## Quick Start
1. Create an [openai account](https://chat.openai.com/auth/login), if you don't already have one

2. Create a [secrete API key](https://platform.openai.com/account/api-keys)

3. Choose a [model](https://platform.openai.com/docs/models) to interact with

```julia
secret_key = "YOUR_SECRETE_KEY_HERE"
model = "gpt-3.5-turbo"
prompt =  "Say \"this is a test\""

r = create_chat(
    secret_key, 
    model,
    [Dict("role" => "user", "content"=> prompt)]
  )
println(r.response[:choices][begin][:message][:content])
```

returns
```julia
"This is a test."
```


For more use cases [see tests](https://github.com/rory-linehan/OpenAI.jl/tree/main/test).

## Feature requests
Feel free to open a PR, or file an issue if that's out of reach!
