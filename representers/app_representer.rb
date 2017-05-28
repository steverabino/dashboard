require 'representable/json'

module AppRepresenter
  include Representable::JSON

  nested :application do
    property :id
    property :name
    property :health_status
    property :reporting
    nested :application_summary do
      property :response_time
      property :throughput
      property :error_rate
    end
  end
end
