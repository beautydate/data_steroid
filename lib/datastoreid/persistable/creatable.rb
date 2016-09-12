module Datastoreid
  module Persistable
    # Defines behaviour for create operations.
    module Creatable
      extend ActiveSupport::Concern

      class_methods do
        def create(params)
          obj = new params
          return false if obj.invalid?
          obj.save ? obj : nil
        end
      end
    end
  end
end
