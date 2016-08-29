require "sinatra"
require "logger"

should_drain = false

set :bind, '0.0.0.0'

get "/" do
  "It's alive!"
end

get "/health" do
  if should_drain
    status 503 # service unavailable
  else
    status 200
  end
end

Signal.trap('INT') { should_drain = true }
