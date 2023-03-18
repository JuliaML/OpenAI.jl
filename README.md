
# OpenAI API wrapper for Julia
=============

## Overview
Provides a Julia wrapper to the OpenAI API.
For API functionality see [reference documentation](https://platform.openai.com/docs/api-reference)

## Usage
`using Pkg; Pkg.add("DataFrames")`

## Quick Start
1. Create an [openai account](https://chat.openai.com/auth/login) if you don't already have one

2. Create a [secrete API key](https://platform.openai.com/account/api-keys)

3. Copy and past your `secrete key`
`secret_key = "YOUR_SECRETE_KEY_HERE"`

4. choose an [openapi model](https://platform.openai.com/docs/models) to interact with
Note: gpt-3.5-turbo is recommended as it is the the cheapest chat model as of March 18, 2023
`model = "gpt-3.5-turbo"`

5. Define a prompt
`prompt =  "Say \"this is a test\""`

6. Create a request
```
r = create_chat(
    secret_key, 
    model,
    [Dict("role" => "user", "content"=> prompt)]
  )
```

7. Print model response
`println(r.response[:choices][begin][:message][:content])`
returns
`This is a test.`

See tests for other example usage.

## Feature requests
Feel free to open a PR, or file an issue if that's out of reach!
