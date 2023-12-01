
"""
    Create assistants

Returns an `OpenAIResponse` object containing an `assistant`.
The `assistant` object contains all fields 

# Arguments:
- `api_key::String`: OpenAI API key
- `model_id::String`: Model id (e.g. "text-davinci-assistant-001")
- `name::String` (optional): The name of the assistant.
- `description::String` (optional): The description of the assistant.
- `instructions::String` (optional): The instructions for the assistant.
- `tools::Vector` (optional): The tools for the assistant. May include
  `code_interpreter`, `retrieval`, or `function`.
- `file_ids::Vector` (optional): The file IDs that are attached to the assistant.
  There can be a maximum of 20 files attached to the assitant. Optional.
- `metadata::Dict` (optional): The metadata for the assistant.
  This is used primarily for record keeping. Up to 16 key-value pairs
  can be included in the metadata. Keys can be up to 64 characters long
  and values can be a maximum of 512 characters long.

# Keyword Arguments:
- `http_kwargs::NamedTuple`: Optional. Keyword arguments to pass to HTTP.request.

For more details about the endpoint, visit 
<https://platform.openai.com/docs/api-reference/assistants/create>.

# Usage 

```julia
assistant = create_assistant(
    api_key,
    "gpt-3.5-turbo-1106",
    name="My Assistant",
    description="My first assistant",
    instructions="This is my first assistant",
    tools=["code_interpreter", "retrieval", "function"],
    file_ids=["file-1234", "file-5678"],
    metadata=Dict("key1" => "value1", "key2" => "value2")
)
```

should return something like

```
Main.OpenAI.OpenAIResponse{JSON3.Object{Vector{UInt8}, Vector{UInt64}}}(200, {
             "id": "asst_i1MDikQGNk2PJGtltQljCI6X",
         "object": "assistant",
     "created_at": 1701360630,
           "name": "My Assistant",
    "description": "My first assistant",
          "model": "gpt-3.5-turbo-1106",
   "instructions": "This is my first assistant",
          "tools": [],
       "file_ids": [],
       "metadata": {
                      "key2": "value2",
                      "key1": "value1"
                   }
})
```
"""

function create_assistant(
    api_key::String,
    model_id::String;
    name::String="",
    description::String="",
    instructions::String="",
    tools::Vector=[],
    file_ids::Vector=[],
    metadata::Dict=Dict(),
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # POST https://api.openai.com/v1/assistants
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "assistants",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        model=model_id,
        name=name,
        description=description,
        instructions=instructions,
        tools=tools,
        file_ids=file_ids,
        metadata=metadata
    )
end

"""
    Get assistant

Returns an `OpenAIResponse` object for a specific assistant.

# Arguments:
- `api_key::String`: OpenAI API key
- `assistant_id::String`: Assistant id (e.g. "asst_i1MDikQGNk2PJGtltQljCI6X")

# Keyword Arguments:
- `http_kwargs::NamedTuple`: Optional. Keyword arguments to pass to HTTP.request.

For more details about the endpoint, visit
<https://platform.openai.com/docs/api-reference/assistants/getAssistant>.

# Usage

```julia
assistant = get_assistant(
    api_key,
    "asst_i1MDikQGNk2PJGtltQljCI6X"
)
```

should return something like

```
Main.OpenAI.OpenAIResponse{JSON3.Object{Vector{UInt8}, Vector{UInt64}}}(200, {
             "id": "asst_i1MDikQGNk2PJGtltQljCI6X",
         "object": "assistant",
     "created_at": 1701360630,
           "name": "My Assistant",
    "description": "My first assistant",
          "model": "gpt-3.5-turbo-1106",
   "instructions": "This is my first assistant",
          "tools": [],
       "file_ids": [],
       "metadata": {
                      "key2": "value2",
                      "key1": "value1"
                   }
})
```
"""
function get_assistant(
    api_key::String,
    assistant_id::String;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # GET https://api.openai.com/v1/assistants/:assistant_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "assistants/$(assistant_id)",
        api_key;
        method="GET",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end


"""
    List assistants

Returns an `OpenAIResponse` object containing a list of assistants,
sorted by the `created_at` timestamp of the objects.

# Arguments:
- `api_key::String`: OpenAI API key

# Keyword Arguments:
- `limit::Integer` (optional): The maximum number of assistants to return. 
  Defaults to 20, must be between 1 and 100.
- `order::String` (optional): The order to list the assistants in, 
  may be `asc` or `desc`. Defaults to `desc` (newest first).
- `after` (optional): A cursor for use in pagination.
  `after` is an object ID that defines your place in the list. 
  For instance, if you make a list request and receive 100 objects, 
  ending with `obj_foo`, your subsequent call can include `after=obj_foo` 
  in order to fetch the next page of the list.
- `before` (optional): A cursor for use in pagination.
  `before` is an object ID that defines your place in the list. 
  For instance, if you make a list request and receive 100 objects, 
  starting with `obj_bar`, your subsequent call can include `before=obj_bar` 
  in order to fetch the previous page of the list.
- `http_kwargs::NamedTuple`: Optional. Keyword arguments to pass to HTTP.request.

For more details about the endpoint, visit
<https://platform.openai.com/docs/api-reference/assistants/listAssistants>.

# Usage

```julia
assistants = list_assistants(
    api_key,
    limit=2,
)
```

should return something like

```
Main.OpenAI.OpenAIResponse{JSON3.Object{Vector{UInt8}, Vector{UInt64}}}(200, {
     "object": "list",
       "data": [
                 {
                              "id": "asst_i1MDikQGNk2PJGtltQljCI6X",
                          "object": "assistant",
                      "created_at": 1701360630,
                            "name": "My Assistant",
                     "description": "My first assistant",
                           "model": "gpt-3.5-turbo-1106",
                    "instructions": "This is my first assistant",
                           "tools": [],
                        "file_ids": [],
                        "metadata": {
                                       "key2": "value2",
                                       "key1": "value1"
                                    }
                 }
               ],
   "first_id": "asst_i1MDikQGNk2PJGtltQljCI6X",
    "last_id": "asst_i1MDikQGNk2PJGtltQljCI6X",
   "has_more": false
})
```
"""
function list_assistants(
    api_key::AbstractString;
    limit::Union{Integer,AbstractString}=20,
    order::AbstractString="desc",
    after::AbstractString="",
    before::AbstractString="",
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # GET https://api.openai.com/v1/assistants
    # Requires the OpenAI-Beta: assistants=v1 header

    # Build query parameters
    query = Pair{String,String}[
        "limit"=>string(limit),
        "order"=>order
    ]
    length(after) > 0 && push!(query, "after" => after)
    length(before) > 0 && push!(query, "before" => before)

    # Make the request to OpenAI
    openai_request(
        "assistants",
        api_key;
        method="GET",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        query=query,
        http_kwargs=http_kwargs,
    )
end

"""
    Update assistant

assistants = list_assistants(
    api_key,
    limit=2,
    )

# Arguments
- `api_key::String`: OpenAI API key
- `assistant_id::String`: Assistant id (e.g. "asst_i1MDikQGNk2PJGtltQljCI6X")

# Keyword Arguments
- `model_id::String`: Optional. The model ID to use for the assistant.
- `name::String`: Optional. The name of the assistant.
- `description::String`: Optional. The description of the assistant.
- `instructions::String`: Optional. The instructions for the assistant.
- `tools::Vector`: Optional. The tools for the assistant. May include
  `code_interpreter`, `retrieval`, or `function`.
- `file_ids::Vector`: Optional. The file IDs that are attached to the assistant.
- `metadata::Dict`: Optional. The metadata for the assistant.
  This is used primarily for record keeping. Up to 16 key-value pairs
  can be included in the metadata. Keys can be up to 64 characters long
  and values can be a maximum of 512 characters long.
- `http_kwargs::NamedTuple`: Optional. Keyword arguments to pass to HTTP.request.

For more details about the endpoint, visit
<https://platform.openai.com/docs/api-reference/assistants/modifyAssistant>.

# Usage

```julia
assistant = modify_assistant(
    api_key,
    "asst_i1MDikQGNk2PJGtltQljCI6X",
    name="My Assistant, renamed",
)
```

should return something like

```
Main.OpenAI.OpenAIResponse{JSON3.Object{Vector{UInt8}, Vector{UInt64}}}(200, {
             "id": "asst_i1MDikQGNk2PJGtltQljCI6X",
         "object": "assistant",
     "created_at": 1701360630,
           "name": "My Assistant, renamed",
    "description": "My first assistant",
          "model": "gpt-3.5-turbo-1106",
   "instructions": "This is my first assistant",
          "tools": [],
       "file_ids": [],
       "metadata": {
                      "key2": "value2",
                      "key1": "value1"
                   }
})
```
"""
function modify_assistant(
    api_key::AbstractString,
    assistant_id::AbstractString;
    model=nothing,
    name=nothing,
    description=nothing,
    instructions=nothing,
    tools=nothing,
    file_ids=nothing,
    metadata=nothing,
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # PATCH https://api.openai.com/v1/assistants/:assistant_id
    # Requires the OpenAI-Beta: assistants=v1 header

    # Collect all fields that are not empty 
    # and store them in a named tuple to be passed on 
    # as kwargs. This only grabs fields that are not empty,
    # so that we don't overwrite existing values with empty ones.
    kwargs = Dict()
    !isnothing(model) && (kwargs["model"] = model)
    !isnothing(name) && (kwargs["name"] = name)
    !isnothing(description) && (kwargs["description"] = description)
    !isnothing(instructions) && (kwargs["instructions"] = instructions)
    !isnothing(tools) && (kwargs["tools"] = tools)
    !isnothing(file_ids) && (kwargs["file_ids"] = file_ids)
    !isnothing(metadata) && (kwargs["metadata"] = metadata)

    # Convert kwargs to namedtuple
    key_tuple = Tuple(map(Symbol, k for k in keys(kwargs)))
    value_tuple = Tuple(v for v in values(kwargs))
    kwarg_nt = NamedTuple{key_tuple}(value_tuple)

    openai_request(
        "assistants/$(assistant_id)",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        kwarg_nt...
    )
end

"""
    Delete assistant

Delete an assistant by ID.

# Arguments:
- `api_key::String`: OpenAI API key
- `assistant_id::String`: Assistant id (e.g. "asst_i1MDikQGNk2PJGtltQljCI6X")

# Keyword Arguments:
- `http_kwargs::NamedTuple`: Optional. Keyword arguments to pass to HTTP.request.

For more details about the endpoint, visit
<https://platform.openai.com/docs/api-reference/assistants/deleteAssistant>.

# Usage

```julia
# Create an assistant to delete
resp = create_assistant(
    api_key,
    "gpt-3.5-turbo-1106",
    name="My Assistant",
)
resp_id = resp.response.id

# Delete that assistant
delete_assistant(
    api_key,
    resp_id,
)
```

should return something like

```
Main.OpenAI.OpenAIResponse{JSON3.Object{Vector{UInt8}, Vector{UInt64}}}(200, {
        "id": "asst_15GkSjSnF5SzGpItO22L6JYI",
    "object": "assistant.deleted",
   "deleted": true
})
```
"""
function delete_assistant(
    api_key::AbstractString,
    assistant_id::AbstractString;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # DELETE https://api.openai.com/v1/assistants/:assistant_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "assistants/$(assistant_id)",
        api_key;
        method="DELETE",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end

###########
# Threads #
###########

"""
    Create thread

    POST https://api.openai.com/v1/threads

# Arguments:
- `api_key::String`: OpenAI API key
- `messages::Vector`: A list of messages to create the thread with. 
  Messages are dictionaries with the following fields: 
    - `role`: The role of the message. Currently only `user` is supported.
    - `content`: The content of the message.
    - `file_ids`: Optional. A list of file IDs to attach to the message.
    - `metadata`: Optional. Metadata for the message.

# Keyword Arguments:
- `http_kwargs::NamedTuple`: Optional. Keyword arguments to pass to HTTP.request.'

# Usage

```julia
thread_id = create_thread(api_key, [
    Dict("role" => "user", "content" => "Hello, how are you?")
]).response.id
```
"""
function create_thread(
    api_key::AbstractString,
    messages=nothing;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # POST https://api.openai.com/v1/threads
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        messages=messages
    )
end

"""
    retrieve thread

Retrieves a thread by ID.

```julia
thread = retrieve_thread(api_key, thread_id)
```
"""
function retrieve_thread(
    api_key::AbstractString,
    thread_id::AbstractString;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # GET https://api.openai.com/v1/threads/:thread_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)",
        api_key;
        method="GET",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end


"""
    delete thread

Delete a thread by ID.

```julia
delete_thread(api_key, thread_id)
```
"""
function delete_thread(
    api_key::AbstractString,
    thread_id::AbstractString;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # DELETE https://api.openai.com/v1/threads/:thread_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)",
        api_key;
        method="DELETE",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end

"""
modify thread

```julia
# Create a thread
thread_id = create_thread(api_key, [
    Dict("role" => "user", "content" => "Hello, how are you?")
]).response.id

# Modify the thread
modify_thread(api_key, thread_id, metadata=Dict("key" => "value"))
```
"""
function modify_thread(
    api_key::AbstractString,
    thread_id::AbstractString;
    metadata=nothing,
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # PATCH https://api.openai.com/v1/threads/:thread_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        metadata=metadata
    )
end

###########
# Message #
###########

"""
    create message

"""
function create_message(
    api_key::AbstractString,
    thread_id::AbstractString,
    # role::AbstractString, # Currently role is always "user"
    content::AbstractString;
    file_ids=nothing,
    metadata=nothing,
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # POST https://api.openai.com/v1/threads/:thread_id/messages
    # Requires the OpenAI-Beta: assistants=v1 header

    # Collect all fields that are not empty 
    # and store them in a named tuple to be passed on 
    # as kwargs. This only grabs fields that are not empty,
    # so that we don't overwrite existing values with empty ones.
    kwargs = Dict()
    !isnothing(file_ids) && (kwargs["file_ids"] = file_ids)
    !isnothing(metadata) && (kwargs["metadata"] = metadata)

    # Convert kwargs to namedtuple
    key_tuple = Tuple(map(Symbol, k for k in keys(kwargs)))
    value_tuple = Tuple(v for v in values(kwargs))
    kwarg_nt = NamedTuple{key_tuple}(value_tuple)

    openai_request(
        "threads/$(thread_id)/messages",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        content=content,
        role="user", # Currently role is always "user", but this may change
        kwarg_nt...
    )
end

"""
    retrieve message

Retrieves a message by ID.
"""
function retrieve_message(
    api_key::AbstractString,
    thread_id::AbstractString,
    message_id::AbstractString;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # GET https://api.openai.com/v1/threads/:thread_id/messages/:message_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)/messages/$(message_id)",
        api_key;
        method="GET",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end

"""
    delete message
    
"""
function delete_message(
    api_key::AbstractString,
    thread_id::AbstractString,
    message_id::AbstractString;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # DELETE https://api.openai.com/v1/threads/:thread_id/messages/:message_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)/messages/$(message_id)",
        api_key;
        method="DELETE",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end

"""
    modify message

"""
function modify_message(
    api_key::AbstractString,
    thread_id::AbstractString,
    message_id::AbstractString;
    metadata=nothing,
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # PATCH https://api.openai.com/v1/threads/:thread_id/messages/:message_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)/messages/$(message_id)",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        metadata=metadata
    )
end

"""
    list messages

Returns an `OpenAIResponse` object containing a list of messages,
sorted by the `created_at` timestamp of the objects.
"""
function list_messages(
    api_key::AbstractString,
    thread_id::AbstractString;
    limit::Union{Integer,AbstractString}=20,
    order::AbstractString="desc",
    after::AbstractString="",
    before::AbstractString="",
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # GET https://api.openai.com/v1/threads/:thread_id/messages
    # Requires the OpenAI-Beta: assistants=v1 header

    # Build query parameters
    query = Pair{String,String}[
        "limit"=>string(limit),
        "order"=>order
    ]
    length(after) > 0 && push!(query, "after" => after)
    length(before) > 0 && push!(query, "before" => before)

    # Make the request to OpenAI
    openai_request(
        "threads/$(thread_id)/messages",
        api_key;
        method="GET",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        query=query,
        http_kwargs=http_kwargs,
    )
end

########
# Runs #
########

"""
    create run

POST https://api.openai.com/v1/threads/{thread_id}/runs
"""
function create_run(
    api_key::AbstractString,
    thread_id::AbstractString,
    assistant_id::AbstractString,
    instructions=nothing;
    tools=nothing,
    metadata=nothing,
    model=nothing,
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # POST https://api.openai.com/v1/threads/:thread_id/runs
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)/runs",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        assistant_id=assistant_id,
        instructions=instructions,
        tools=tools,
        metadata=metadata,
        model=model
    )
end

"""
    retrieve run

GET https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}
"""
function retrieve_run(
    api_key::AbstractString,
    thread_id::AbstractString,
    run_id::AbstractString;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # GET https://api.openai.com/v1/threads/:thread_id/runs/:run_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)/runs/$(run_id)",
        api_key;
        method="GET",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end

"""
    modify run

POST https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}
"""
function modify_run(
    api_key::AbstractString,
    thread_id::AbstractString,
    run_id::AbstractString;
    metadata=nothing,
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # POST https://api.openai.com/v1/threads/:thread_id/runs/:run_id
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)/runs/$(run_id)",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs,
        metadata=metadata
    )
end

"""
    list runs

GET https://api.openai.com/v1/threads/{thread_id}/runs
"""
function list_runs(
    api_key::AbstractString,
    thread_id::AbstractString;
    limit::Union{Integer,AbstractString}=20,
    order::AbstractString="desc",
    after::AbstractString="",
    before::AbstractString="",
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # GET https://api.openai.com/v1/threads/:thread_id/runs
    # Requires the OpenAI-Beta: assistants=v1 header

    # Build query parameters
    query = Pair{String,String}[
        "limit"=>string(limit),
        "order"=>order
    ]
    length(after) > 0 && push!(query, "after" => after)
    length(before) > 0 && push!(query, "before" => before)

    # Make the request to OpenAI
    openai_request(
        "threads/$(thread_id)/runs",
        api_key;
        method="GET",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        query=query,
        http_kwargs=http_kwargs,
    )
end

"""
    Cancel run

POST https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}/cancel
"""
function cancel_run(
    api_key::AbstractString,
    thread_id::AbstractString,
    run_id::AbstractString;
    http_kwargs::NamedTuple=NamedTuple()
)
    # The API endpoint is
    # POST https://api.openai.com/v1/threads/:thread_id/runs/:run_id/cancel
    # Requires the OpenAI-Beta: assistants=v1 header
    openai_request(
        "threads/$(thread_id)/runs/$(run_id)/cancel",
        api_key;
        method="POST",
        additional_headers=[("OpenAI-Beta", "assistants=v1")],
        http_kwargs=http_kwargs
    )
end
