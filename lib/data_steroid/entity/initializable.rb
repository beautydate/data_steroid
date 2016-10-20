module DataSteroid
  module Entity
    # Define behaviour for initialization of Entity.
    module Initializable
      extend ActiveSupport::Concern

      included do
        def initialize(params = nil)
          set_default_values
          case params
          when Google::Cloud::Datastore::Entity
            properties_names.each do |property_name|
              send("#{property_name}=", params[property_name.to_s])
            end
            send('id=', params.key.id)
          when ::Hash
            params.each_pair do |key, value|
              send("#{key}=", value)
            end
          end
        end
      end
    end
  end
end
