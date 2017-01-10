defmodule Dashboard.SampleData.Nodes do
  def data do
    %{

      # http://localhost:4000/endpoint?uuid=tr1&to[number]=7153380283&to[city]=Fargo&to[state]=ND&from[number]=7153333333&from[city]=Fargo&from[state]=north%20dakota

      0 => %{ # Triggers are recievers of information, they need to set what data is available in the variable list
        # after the event.  Default is everything with the default names.  Below shows allowing nested variables
        # with the parents being renamed and the caller_ids being custom formatted.
        id: 0,
        uuid: "tr1",
      	page_id: 0,
      	type: "Trigger",
      	name: "Twilio::Calls.recieve",
        authentication_id: 0,
        default_body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<Response>
    <Say voice=\"woman\">Please leave a message after the tone.</Say>
    <Record/>
</Response>",
        default_status: 200,
        default_content_type: "text/xml",
        method: :post,
        timeout: 10000, # If there is no response sent then send the default response.
        expose: %{
          "recipient" => %{
            "phone_number" => "{{ To }}",
            "caller_id" => "{{ titleize(ToCity) }}, {{ abbreviate(ToState, :state) }}"
            # truncated is a large function that searches for possible shortened version of the string
            # This might need some work to optimize it
          },
          "caller" => %{
            "phone_number" => "{{ From }}",
            "caller_id" => "{{ titleize(FromCity) }}, {{ abbreviate(FromState, :state) }}"
          }
        },
        next: [3]
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
        expose: %{
          "recipient" => %{
            "phone_number" => "{{ to.number }}",
            "caller_id" => "{{ join([titleize(ToCity), abbreviate(ToState, :state) ], \",\") }}"
            # truncated is a large function that searches for possible shortened version of the string
            # This might need some work to optimize it
          },
          "caller" => %{
            "phone_number" => "{{ from.number }}",
            "caller_id" => "{{ join([titleize(FromCity), abbreviate(FromState, :state) ], \",\") }}"
          }
        },
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
        lhs: "7153380283",
        rhs: "[{{ misc }}]",
  	    operator: "in",
        serializer: "phone_number",
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
        url: "https://hooks.slack.com/services/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",
        content_type: "application/json",
        authentication_id: 2,
        data: %{
          text: "New call from {{ caller.caller_id }} - {{ format(caller.phone_number, \"+# (###) ###-####\", :phone_number) }}"
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
