require 'faraday'

module Api
  class NewRelic
    BASE_URL = 'https://api.newrelic.com/v2/'
    API_KEY = ENV['NEWRELIC_API_KEY']

    def server(server_id)
      connect("servers/#{server_id}.json")
    end

    def application(app_id)
      connect("applications/#{app_id}.json")
    end

    private

    def connect(path)
      output = Faraday.get do |req|
        req.url (BASE_URL + path)
        req.headers['X-Api-Key'] = API_KEY
      end
    end
  end
end
