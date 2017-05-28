require './lib/newrelic_api'
require './representers/server_representer'
require './representers/app_representer'

class Server
  attr_accessor :id, :name, :health_status, :reporting, :cpu, :memory
end

class Application
  attr_accessor :id, :name, :health_status, :reporting, :response_time, :throughput, :error_rate
end

config = YAML::load_file('config/newrelic.yml')

# Newrelic API key
key = ENV['NEWRELIC_API_KEY']

# Monitored application
app_name = ENV['NEWRELIC_APP_NAME']

# Emitted metrics:
# - rpm_apdex
# - rpm_error_rate
# - rpm_throughput
# - rpm_errors
# - rpm_response_time
# - rpm_db
# - rpm_cpu
# - rpm_memory

SCHEDULER.every '1m', :first_in => 0 do |job|

  api = Api::NewRelic.new
  server_blueprint = Server.new.extend(ServerRepresenter)
  app_blueprint = Application.new.extend(AppRepresenter)

  config['servers'].each do |id|
    server = server_blueprint.from_json(api.server(id).body)
    send_event("newrelic-server-memory-#{id}", { value: server.memory })
    send_event("newrelic-server-cpu-#{id}", { value: server.cpu })
  end

  config['applications'].each do |id|
    app = app_blueprint.from_json(api.application(id).body)
    send_event("newrelic-app-response-#{id}", { current: app.response_time })
    send_event("newrelic-app-throughput-#{id}", { current: app.throughput })
    send_event("newrelic-app-error_rate-#{id}", { current: app.error_rate })
  end
end
