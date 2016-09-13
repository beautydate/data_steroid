module Datastoreid
  module Entity
    # Define behaviour for initialization of Entity.
    module Initializable
      extend ActiveSupport::Concern

      included do
        def initialize(options = nil)
          set_default_values
          if options.is_a? Google::Cloud::Datastore::Entity
            properties_names.each { |a| send("#{a}=", options[a.to_s]) }
            send('id=', options.key.id)
          elsif options.is_a? ::Hash
            options.each_pair { |key, value| send("#{key}=", value) }
          end
        end
      end
    end
  end
end
