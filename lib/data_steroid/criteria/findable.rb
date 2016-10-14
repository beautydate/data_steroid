module DataSteroid
  module Criteria
    # Defines behaviour for find operations.
    module Findable
      extend ActiveSupport::Concern

      class_methods do
        def find(id)
          run query.where('__key__', '=', gcloud_key(id.to_i))
        end
      end
    end
  end
end
