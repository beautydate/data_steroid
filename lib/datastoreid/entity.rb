require 'google/cloud/datastore/entity'

module Datastoreid
  # Inject behaviour for Datastore Entity.
  module Entity
    extend ActiveSupport::Concern

    include Criteria
    include Persistable
    include Properties
    include Validatable

    include Entity::Initializable

    included do
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      class_attribute :kind

      def persisted?
        id.present?
      end

      def gcloud_key
        self.class.datastore.key(kind, id)
      end

      def to_gcloud
        hash = {}
        properties_names.each do |property|
          hash[property] = send(property)
        end
        hash.sort.to_h
      end

      def to_csv
        values = to_gcloud.sort.to_h.values.map! do |v| 
          if v.class == Time
            v.to_formatted_s(:db)
          else
            v.to_s.gsub(',', '')
          end
        end
        values.join(',')
      end

      def self.kind(kind_name)
        self.kind = kind_name
      end
    end

    class_methods do
      def datastore
        @datastore ||= Gcloud.new.datastore
      end

      def datastore_entity
        datastore.entity kind
      end

      protected

      def gcloud_key(id)
        datastore.key(kind, id)
      end
    end
  end
end
