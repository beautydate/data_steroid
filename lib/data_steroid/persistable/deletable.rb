module DataSteroid
  module Persistable
    # Defines behaviour for delete operations.
    module Deletable
      extend ActiveSupport::Concern

      included do
        def delete
          @gcloud_entity ||= self.class.datastore_entity
          if !@gcloud_entity.persisted? && id.present?
            @gcloud_entity.key = gcloud_key
          end
          self.class.datastore.delete @gcloud_entity
        end
      end
    end
  end
end
