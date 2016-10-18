module DataSteroid
  module Entity
    # Define behaviour for initialization of Entity.
    module Initializable
      extend ActiveSupport::Concern

      included do
        def initialize(options = nil)
          super(options)
          if options.is_a? Google::Cloud::Datastore::Entity
            send('id=', options.key.id)
          end
        end
      end
    end
  end
end
