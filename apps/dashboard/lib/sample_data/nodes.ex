defmodule Dashboard.SampleData.Nodes do
  def data do
    %{
      0 => %{ # Triggers are recievers of information, they need to set what data is available in the variable list
        # after the event.  Default is everything with the default names.  Below shows allowing nested variables
        # with the parents being renamed and the caller_ids being custom formatted.
        id: 0,
        uuid: "tr1",
      	page_id: 0,
      	type: "Trigger",
      	name: "Twilio::Calls.recieve",
        authentication_id: 0,
        default_body: "<twiml send-to-vm></twiml>",
        default_status: 200,
        method: :post,
        timeout: 10000, # If there is no response sent then send the default response.
        expose: [
          to: %{
            __as__: "recipient",
            phone_number: "number",
            caller_id: "<%= city %>, <%= truncate(state) %>"
            # truncated is a large function that searches for possible shortened version of the string
            # This might need some work to optimize it
          },
          from: %{
            __as__: "caller",
            phone_number: "number",
            caller_id: "<%= city %>, <%= truncate(state) %>"
          }
        ],
        next: [2]
      },
      1 => %{
      	id: 1,
        uuid: "tr2",
      	page_id: 1,
      	type: "Trigger",
      	name: "Twilio::Calls.recieve",
        authentication_id: 1,
        default_body: "<twiml send-to-vm></twiml>",
        default_status: 200,
        method: :post,
        timeout: 10000,
        expose: [
          to: %{
            __as__: "recipient",
            phone_number: "number",
            caller_id: "<%= city %>, <%= truncate(state) %>"
          },
          from: %{
            __as__: "caller",
            phone_number: "number",
            caller_id: "<%= city %>, <%= truncate(state) %>"
          }
        ],
        next: [] # Doesn't need to go to a new node, it will just respond with the default after the timeout.
      },
      2 => %{ # A condition takes a left and right side as well as the comparison operator.  This might be expanded to handle larger or
        # even changed to just be the cond operator.  The values can be either static (typed into a form) or a variable from the
        # list.  Comparisons can be 'optimized' for certain operations with serializers.  These could be phone numbers, email addresses,
        # currency, case insensative, or (possible a complex object match.).  This sets a variable to true or false as end result.
        # If variable is not provide, it is not passed along.  Add a default (true|false) response.  Halt will look at any pending
        # responses and send the defaults or different value if set.
  	    id: 2,
        page: 0,
        type: "Condition",
        variable: "my_number?",
        default_false: :halt,
        lhs: %{
          type: "var",
          value: "twilio-0.to.number",
        },
        rhs: %{
  		    type: "static",
  		    value: "7153380283",
  	    },
  	    cond: %{
  		    compare: "eq",
  		    serialize: "phone_number",
  	    },
        next_true: [3],
        next_false: []
      },
      3 => %{ # Actions are Posts to servers, they will only return a status of failed, or success as their variable.
         # This example will set slack-3.status.  If there is no next and no default, :halt is called.
       	id: 3,
       	page_id: 0,
       	type: "Action",
       	name: "Slack::Channel.post",
        method: :post,
        authentication_id: 2,
        action: %{
          channel: "general",
          contents: "New call from <%= twilio-0.from.caller_id %> - <%= string_to_phone_number(twilio-0.from.number, \"(###) ###-####\") %>"
        },
        next: []
      },
      4 => %{ # Triggers are recievers of information, they need to set what data is available in the variable list
        # after the event.  Default is everything with the default names.  Below shows allowing nested variables
        # with the parents being renamed and the caller_ids being custom formatted.
        id: 4,
        uuid: "tr3",
      	page_id: 2,
      	type: "Trigger",
      	name: "Ping",
        default_body: "Pong",
        default_status: 200,
        method: :any,
        timeout: 0, # Respond right away.
        next: [5]
      },
      5 => %{
        id: 5,
        page_id: 2,
        type: "Computation",
        name: "Log",
        message: "[LOG] Replied to a ping with a pong",
        next: []
      }
    }
  end
end
