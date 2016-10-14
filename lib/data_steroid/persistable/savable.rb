module DataSteroid
  module Persistable
    # Defines behaviour for save operations.
    module Savable
      extend ActiveSupport::Concern

      included do
        class_attribute :before_save_methods

        self.before_save_methods = []

        def save
          return false if invalid?

          before_save_methods.each do |name|
            send(name)
          end

          @gcloud_entity ||= self.class.datastore_entity

          to_gcloud.each_pair do |key, value|
            if key == 'id' && value.present?
              @gcloud_entity.key = gcloud_key unless @gcloud_entity.persisted?
              next
            end
            if value.present?
              @gcloud_entity[key] = value
            elsif @gcloud_entity.properties.exist? key
              @gcloud_entity.properties.delete key
            end
          end

          if (result = self.class.datastore.save(@gcloud_entity).first)
            send('id=', result.key.id) if id.nil?
            true
          else
            false
          end
        end
      end
      
      class_methods do
        def before_save(method)
          before_save_methods << method
        end
      end
    end
  end
end
