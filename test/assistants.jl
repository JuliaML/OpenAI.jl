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
test_model = "gpt-4o-mini"

# Test functions for the assistant generation/modification/etc.
@testset "Assistants" begin
    # Make an assistant
    new_assistant = create_assistant(api_key,
        test_model;
        name = "Testing",
        description = "A description",
        instructions = "You make cool stuff sometimes",
        metadata = Dict())

    # Retrieve the assistant we made, assert that it's the same
    retrieved_assistant = get_assistant(api_key,
        new_assistant.response.id;)
    @test retrieved_assistant.response.id == new_assistant.response.id

    # List assistants, assert that the assistant we made is in the list
    assistant_list = list_assistants(api_key)
    ids = map(x -> x.id, assistant_list.response.data)
    @test new_assistant.response.id in ids

    # Modify the assistant
    modded_assistant = modify_assistant(api_key,
        new_assistant.response.id;
        name = "Testing 2",
        description = "A description 2",
        instructions = "You make cool stuff sometimes 2",
        metadata = Dict())
    @test modded_assistant.response.id == new_assistant.response.id

    # Delete the assistant
    delete_result = delete_assistant(api_key,
        new_assistant.response.id;)
    @test delete_result.response.deleted == true
end

@testset "Threads" begin
    # Testing
    # - create_thread
    # - retrieve_thread
    # - modify_thread
    # - delete_thread
    new_thread = create_thread(api_key)
    display(new_thread)

    # Get the thread we just made
    retrieved_thread = retrieve_thread(api_key,
        new_thread.response.id;)
    @test retrieved_thread.response.id == new_thread.response.id

    # Modify the thread
    modded_thread = modify_thread(api_key,
        new_thread.response.id;
        metadata = Dict("test" => "test"))
    @test modded_thread.response.id == new_thread.response.id
    @test modded_thread.response.metadata["test"] == "test"

    # Delete the thread
    delete_result = delete_thread(api_key,
        new_thread.response.id;)
    @test delete_result.response.deleted == true
end

@testset "Messages" begin
    # Testing
    # - create_message
    # - retrieve_message
    # - modify_message
    # - list_messages
    # - delete_message

    # Create a thread to add to
    new_thread = create_thread(api_key)

    # Create a message
    new_message = create_message(api_key,
        new_thread.response.id,
        "Hello, world!";)
    @test new_message.response.content[1].text.value == "Hello, world!"

    # Retrieve the message
    retrieved_message = retrieve_message(api_key,
        new_thread.response.id,
        new_message.response.id;)
    @test retrieved_message.response.content[1].text.value == "Hello, world!"
    @test retrieved_message.response.id == new_message.response.id

    # Modify the message
    modified_message = modify_message(api_key,
        new_thread.response.id,
        new_message.response.id;
        metadata = Dict("test" => "test"))
    @test modified_message.response.id == new_message.response.id
    @test modified_message.response.metadata["test"] == "test"

    # List messages
    message_list = list_messages(api_key,
        new_thread.response.id;)
    ids = map(x -> x.id, message_list.response.data)
    @test new_message.response.id in ids

    # Delete the thread
    delete_result = delete_thread(api_key,
        new_thread.response.id;)
end

@testset "Runs" begin
    # Test the following
    # - create_run
    # - retrieve_run
    # - modify_run
    # - list_runs
    # - cancel_run

    # Make an assistant
    new_assistant = create_assistant(api_key,
        "gpt-3.5-turbo-1106",
        name = "Testing",
        description = "A description",
        instructions = "You make cool stuff sometimes",
        metadata = Dict())

    # Make a thread
    thread = create_thread(api_key,
        [
            Dict("role" => "user", "content" => "Hello, how are you?"),
        ])

    # Make a run
    new_run = create_run(api_key,
        thread.response.id,
        new_assistant.response.id)

    # Test that the assistant id in the run is the same as the one we made
    @test new_run.response.assistant_id == new_assistant.response.id
    @test new_run.response.status == "queued" # Might break the tests if this changes

    # Retrieve the run
    run = retrieve_run(api_key,
        thread.response.id,
        new_run.response.id)
    @test run.response.id == new_run.response.id

    # List the runs
    runs = list_runs(api_key,
        thread.response.id)
    ids = map(x -> x.id, runs.response.data)
    @test new_run.response.id in ids

    # modify the run
    sleep(4) # wait until run is complete
    modded_run = modify_run(api_key,
        thread.response.id,
        new_run.response.id,
        metadata = Dict("key" => "value"))
    @test modded_run.response.id == new_run.response.id

    # Cancel the run. This will fail if the run is already completed. 
    # Not sure how to test this well.
    # cancel_result = cancel_run(
    #     api_key,
    #     thread.response.id,
    #     new_run.response.id
    # )

    # Check the thread
    new_messages = list_messages(api_key,
        thread.response.id)
    @test length(new_messages.response.data) == 2

    # Remove the assistant we made
    delete_assistant(api_key,
        new_assistant.response.id)
end # end testset
