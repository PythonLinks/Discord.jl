module Events

using Dates
using Discord

function on_message_create(c::Client, e::MessageCreate)
    e.message.content == "ping" && reply(c, e.message, "pong")
end

function on_no_handler(c::Client, e::AbstractEvent)
    println("Received unhandled event: $(typeof(e))")
end

function main()
    c = Client(ENV["DISCORD_TOKEN"])
    # This handler will remain valid for one minute.
    add_handler!(c, MessageCreate, on_message_create; tag=:ping, expiry=Minute(1))
    # This handler will run on the first ten events which have no non-default handler.
    add_handler!(c, FallbackEvent, on_no_handler; tag=:fallback, expiry=10)

    # There is also the possibility to use `do` syntax with events
    add_handler!(c, Ready) do c, client_data
        println("Logged in as $(client.user.username).")
    end

    open(c)
    return c
end

end

if abspath(PROGRAM_FILE) == @__FILE__
    c = Events.main()
    wait(c)
end
