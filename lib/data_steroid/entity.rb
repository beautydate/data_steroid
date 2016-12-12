require 'google/cloud/datastore/entity'

module DataSteroid
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

      attr_accessor :parent

      def persisted?
        id.present?
      end

      def gcloud_key
        params = [[kind, id]]
        params.unshift [parent.class.kind, parent.id] if parent.present?
        self.class.datastore.key(*params)
      end

      def as_parent_key
        raise DataSteroid::Errors::InvalidRecord.new('parent not persisted') unless persisted?
        gcloud_key
      end

      def to_gcloud
        properties_names.each_with_object({}) do |property, hash|
          hash[property] = type_cast_for_storage send(property)
        end
      end

      def to_csv
        values = to_gcloud.sort.to_h.values.map! do |value|
          case value
          when Time
            value.to_formatted_s(:db)
          else
            value.to_s.gsub(',', '')
          end
        end
        values.join(',')
      end

      def self.kind(kind_name)
        self.kind = kind_name
      end

      protected

      # Based on https://github.com/rails/rails/blob/v5.0.0.1/activerecord/lib/active_record/type_caster/map.rb
      def type_cast_for_storage(value)
        case value
        when Symbol
          value.to_s
        else
          value
        end
      end
    end

    class_methods do
      def datastore
        @datastore ||= Google::Cloud.new.datastore
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
