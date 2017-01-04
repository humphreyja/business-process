# Dev

On request, spin up a new process to handle the event and a new process to handle the response.  This keeps the computation out of the request thread.  The thread does a CAST and the event fires.  


# Response Server (GenServer)

The thread also does a CALL to the response server.  This server will first look for a RESPONSE.  If it doesn't have a response, then it looks for a DEFAULT_RESPONSE.  If it has a default, it will look for a timeout on that default.  It will wait for that timeout length before sending the default.  During that time, it will continue to check if it has a response.  If one is found, the it will return that.  If no response is set, it will wait 100ms before returning the default 202 status.  
**I could use GenEvent here as well.  This might be the spot to use it.**


/ supervisors
  / compute.ex
  / response.ex
/ core
  / response
  / compute
    / triggers
      / main.ex
      / _other files_


/ supervisors - duh
/ web - anything related to web requirements (like response handling)
/ compute - anything that computes


1. Plug hands conn off to event handler
2. event handler
