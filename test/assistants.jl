# This file tests the following API endpoints:
# Assistants API to implement
#- Create assistant
#- Retrieve assistant
#- Modify assistant
#- Delete assistant
#- List assistants

# Threads
#- Create thread
#- Retrieve thread
#- Modify thread
#- Delete thread

# Messages
#- Create message
#- Retrieve message
#- Delete message
#- Modify message
#- List messages

# Runs
#- Create run
#- Retrieve run
#- Modify run
#- List runs
#- Submit tool outputs to run
#- cancel run
#- create thread and run
#- Retrieve run step
#- List run steps

# Set API/model
api_key = ENV["OPENAI_API_KEY"]
test_model = "gpt-3.5-turbo"

# Test functions for the assistant generation/modification/etc.
@testset "Assistants" begin
    # Make an assistant
    new_assistant = create_assistant(
        api_key,
        test_model;
        name::String="Testing",
        description="A description",
        instructions="You make cool stuff sometimes",
        metadata=Dict(),
    )

    # Retrieve the assistant we made, assert that it's the same
    retrieved_assistant = get_assistant(
        api_key,
        new_assistant.request.id;
    )
    @test retrieved_assistant.request.id == new_assistant.request.id

    # List assistants, assert that the assistant we made is in the list
    assistant_list = list_assistants(api_key)
    ids = map(x -> x.id, assistant_list.request.data)
    @test new_assistant.request.id in ids

    # Modify the assistant
    modded_assistant = modify_assistant(
        api_key,
        new_assistant.request.id;
        name="Testing 2",
        description="A description 2",
        instructions="You make cool stuff sometimes 2",
        metadata=Dict(),
    )
    @test modded_assistant.request.id == new_assistant.request.id

    # Delete the assistant
    delete_result = delete_assistant(
        api_key,
        new_assistant.request.id;
    )
    @test delete_result.response.deleted == true
end