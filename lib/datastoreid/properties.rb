module Datastoreid
  # Define behaviour to properties of entity.
  module Properties
    extend ActiveSupport::Concern

    included do
      class_attribute :properties

      self.properties = {}

      property :id # Default property

      def properties=(properties)
        if properties.is_a? ::Hash
          properties.each_pair { |key, value| send("#{key}=", value) }
        else
          raise Datastore::Errors::DatastoreError.new 'Properties params need is Hash'
        end
      rescue
        raise Datastore::Errors::DatastoreError.new 'Property invalid'
      end

      def properties_names
        properties.keys
      end

      def set_default_values
        properties.each_pair do |name, options|
          send("#{name}=", properties[name][:default]) if options.key? :default
        end
      end
    end

    class_methods do
      protected

      def property(name, options = {})
        add_property(name.to_s, options)
      end

      def add_property(name, options)
        properties[name] = options
        create_accessors(name)
      end

      # https://www.leighhalliday.com/ruby-metaprogramming-creating-methods
      def create_accessors(name)
        define_method(name) do # Define get method
          instance_variable_get("@#{name}")
        end
        define_method("#{name}=") do |value| # Define set method
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end
end
