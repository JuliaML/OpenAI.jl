var documenterSearchIndex = {"docs":
[{"location":"#OpenAI.jl-Documentation","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"","category":"section"},{"location":"","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"list_models(api_key::String; http_kwargs::NamedTuple=NamedTuple())","category":"page"},{"location":"#OpenAI.list_models-Tuple{String}","page":"OpenAI.jl Documentation","title":"OpenAI.list_models","text":"List models\n\nArguments:\n\napi_key::String: OpenAI API key\n\nFor additional details, visit https://platform.openai.com/docs/api-reference/models/list\n\n\n\n\n\n","category":"method"},{"location":"","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"retrieve_model(api_key::String, model_id::String; http_kwargs::NamedTuple=NamedTuple())","category":"page"},{"location":"#OpenAI.retrieve_model-Tuple{String, String}","page":"OpenAI.jl Documentation","title":"OpenAI.retrieve_model","text":"Retrieve model\n\nArguments:\n\napi_key::String: OpenAI API key\nmodel_id::String: Model id\n\nFor additional details, visit https://platform.openai.com/docs/api-reference/models/retrieve\n\n\n\n\n\n","category":"method"},{"location":"","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"create_completion(api_key::String, model_id::String; http_kwargs::NamedTuple=NamedTuple(), kwargs...)","category":"page"},{"location":"#OpenAI.create_completion-Tuple{String, String}","page":"OpenAI.jl Documentation","title":"OpenAI.create_completion","text":"Create completion\n\nArguments:\n\napi_key::String: OpenAI API key\nmodel_id::String: Model id\n\nKeyword Arguments (check the OpenAI docs for the exhaustive list):\n\ntemperature::Float64=1.0: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.\ntop_p::Float64=1.0: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.\n\nFor more details about the endpoint and additional arguments, visit https://platform.openai.com/docs/api-reference/completions\n\nHTTP.request keyword arguments:\n\nhttp_kwargs::NamedTuple=NamedTuple(): Keyword arguments to pass to HTTP.request (e. g., http_kwargs=(connection_timeout=2,) to set a connection timeout of 2 seconds).\n\n\n\n\n\n","category":"method"},{"location":"","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"create_chat","category":"page"},{"location":"#OpenAI.create_chat","page":"OpenAI.jl Documentation","title":"OpenAI.create_chat","text":"Create chat\n\nArguments:\n\napi_key::String: OpenAI API key\nmodel_id::String: Model id\nmessages::Vector: The chat history so far.\nstreamcallback=nothing: Function to call on each chunk (delta) of the chat response in streaming mode.\n\nKeyword Arguments (check the OpenAI docs for the exhaustive list):\n\ntemperature::Float64=1.0: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.\ntop_p::Float64=1.0: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.\n\nnote: Note\nDo not use stream=true option here, instead use the streamcallback keyword argument (see the relevant section below).\n\nFor more details about the endpoint and additional arguments, visit https://platform.openai.com/docs/api-reference/chat\n\nHTTP.request keyword arguments:\n\nhttp_kwargs::NamedTuple=NamedTuple(): Keyword arguments to pass to HTTP.request (e. g., http_kwargs=(connection_timeout=2,) to set a connection timeout of 2 seconds).\n\nExample:\n\njulia> CC = create_chat(\"..........\", \"gpt-3.5-turbo\", \n    [Dict(\"role\" => \"user\", \"content\"=> \"What is the OpenAI mission?\")]\n);\n\njulia> CC.response.choices[1][:message][:content]\n\"\n\nThe OpenAI mission is to create safe and beneficial artificial intelligence (AI) that can help humanity achieve its full potential. The organization aims to discover and develop technical approaches to AI that are safe and aligned with human values. OpenAI believes that AI can help to solve some of the world's most pressing problems, such as climate change, disease, inequality, and poverty. The organization is committed to advancing research and development in AI while ensuring that it is used ethically and responsibly.\"\n\nStreaming\n\nWhen a function that takes a single String as an argument is passed in the streamcallback argument, a request will be made in in streaming mode. The streamcallback callback will be called on every line of the streamed response. Here we use a callback that prints out the current time to demonstrate how different parts of the response are received at different times. \n\nThe response body will reflect the chunked nature of the response, so some reassembly will be required to recover the full message returned by the API.\n\njulia> CC = create_chat(key, \"gpt-3.5-turbo\",\n           [Dict(\"role\" => \"user\", \"content\"=> \"What continent is New York in? Two word answer.\")],\n       streamcallback = x->println(Dates.now()));\n       2023-03-27T12:34:50.428\n2023-03-27T12:34:50.524\n2023-03-27T12:34:50.524\n2023-03-27T12:34:50.524\n2023-03-27T12:34:50.545\n2023-03-27T12:34:50.556\n2023-03-27T12:34:50.556\n\njulia> map(r->r[\"choices\"][1][\"delta\"], CC.response)\n5-element Vector{JSON3.Object{Base.CodeUnits{UInt8, SubString{String}}, SubArray{UInt64, 1, Vector{UInt64}, Tuple{UnitRange{Int64}}, true}}}:\n {\n   \"role\": \"assistant\"\n}\n {\n   \"content\": \"North\"\n}\n {\n   \"content\": \" America\"\n}\n {\n   \"content\": \".\"\n}\n {}\n\n\n\n\n\n","category":"function"},{"location":"","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"create_edit(api_key::String, model_id::String, instruction::String; http_kwargs::NamedTuple=NamedTuple(), kwargs...)","category":"page"},{"location":"#OpenAI.create_edit-Tuple{String, String, String}","page":"OpenAI.jl Documentation","title":"OpenAI.create_edit","text":"Create edit\n\nNote: This functionality is not accessible via API anymore – see https://platform.openai.com/docs/deprecations\n\nArguments:\n\napi_key::String: OpenAI API key\nmodel_id::String: Model id (e.g. \"text-davinci-edit-001\")\ninstruction::String: The instruction that tells the model how to edit the prompt.\ninput::String (optional): The input text to use as a starting point for the edit.\nn::Int (optional): How many edits to generate for the input and instruction.\n\nKeyword Arguments:\n\nhttp_kwargs::NamedTuple (optional): Keyword arguments to pass to HTTP.request.\n\nFor additional details about the endpoint, visit https://platform.openai.com/docs/api-reference/edits\n\n\n\n\n\n","category":"method"},{"location":"","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"create_embeddings(api_key::String, input, model_id::String=DEFAULT_EMBEDDING_MODEL_ID; http_kwargs::NamedTuple=NamedTuple(), kwargs...)","category":"page"},{"location":"#OpenAI.create_embeddings","page":"OpenAI.jl Documentation","title":"OpenAI.create_embeddings","text":"Create embeddings\n\nArguments:\n\napi_key::String: OpenAI API key\ninput: The input text to generate the embedding(s) for, as String or array of tokens.   To get embeddings for multiple inputs in a single request, pass an array of strings       or array of token arrays. Each input must not exceed 8192 tokens in length.       - model_id::String: Model id. Defaults to text-embedding-ada-002.\n  # Keyword Arguments:\n  - `http_kwargs::NamedTuple`: Optional. Keyword arguments to pass to HTTP.request.\n  \n  For additional details about the endpoint, visit <https://platform.openai.com/docs/api-reference/embeddings>\n\n\n\n\n\n","category":"function"},{"location":"","page":"OpenAI.jl Documentation","title":"OpenAI.jl Documentation","text":"create_images(api_key::String, prompt, n::Integer=1, size::String=\"256x256\"; http_kwargs::NamedTuple=NamedTuple(), kwargs...)","category":"page"},{"location":"#OpenAI.create_images","page":"OpenAI.jl Documentation","title":"OpenAI.create_images","text":"Create images\n\nArguments:\n\napi_key::String: OpenAI API key\nprompt: The input text to generate the image(s) for, as String or array of tokens.\nn::Integer: Optional. The number of images to generate. Must be between 1 and 10.\nsize::String: Optional. Defaults to 1024x1024. The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024.\n\nKeyword Arguments:\n\nhttp_kwargs::NamedTuple: Optional. Keyword arguments to pass to HTTP.request.\nresponse_format::String: Optional. Defaults to \"url\". The format of the response. Must be one of \"url\" or \"b64_json\".\n\nFor additional details about the endpoint, visit https://platform.openai.com/docs/api-reference/images/create\n\nonce the request is made,\n\ndownload like this:  download(r.response[\"data\"][begin][\"url\"], \"image.png\")\n\n\n\n\n\n","category":"function"}]
}
