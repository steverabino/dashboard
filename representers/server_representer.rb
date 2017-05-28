require 'representable/json'

module ServerRepresenter
  include Representable::JSON

  nested :server do
    property :id
    property :name
    property :health_status
    property :reporting
    nested :summary do
      property :cpu
      property :memory
    end
  end
end
