require 'coercible'

module DataSteroid
  # Define behaviour to properties of entity.
  module Properties
    extend ActiveSupport::Concern

    included do
      class_attribute :properties

      class << self
        alias_method :property, :add_property
      end

      self.properties = {}

      property :id # Default property

      def properties=(properties)
        if properties.is_a? ::Hash
          properties.each_pair { |key, value| send("#{key}=", value) }
        else
          raise Datastore::Errors::DatastoreError.new 'Properties params must be a Hash'
        end
      rescue
        raise Datastore::Errors::DatastoreError.new 'Property invalid'
      end

      def properties_names
        properties.keys
      end

      protected

      def set_default_values
        properties.each_pair do |name, options|
          next unless options.key? :default
          default = options[:default]
          # Default might be a lambda
          value = default.respond_to?(:call) ? default.call : default
          send("#{name}=", value)
        end
      end

      def coercer
        @coercer ||= Coercible::Coercer.new
      end

      def coerce(value, type)
        if value.nil? || !options[:type]
          value
        else
          case options[:type]
          when Array then coerce_array(value, options[:type])
          when Time  then coerce_time(value)
          else coerce_other(value, options[:type])
          end
        end
      end

      def coerce_array(value, type)
        # type: generic Array
        if type == Array
          element
        # type: Array[Something]
        elsif value.respond_to?(:map)
          value.map do |element|
            coerce(element, type[0])
          end
        else
          value
        end
      end

      def coerce_time(value)
        case value
        when Integer then Time.at(value)
        when String then Time.parse(value)
        else value
        end
      end

      def coerce_other(value, type)
        case value
        when Array
          raise ArgumentError.new "Unsupported type: #{value.class}"
        else
          coercer[value.class].send("to_#{type.to_s.downcase}", simple_value)
        end
      end
    end

    class_methods do
      protected

      def add_property(name, *args)
        options = args[-1].is_a?(Hash) ? args.pop : {}
        options[:type] = args[0] if args[0].is_a?(Class)
        properties[name.to_s] = options
        create_accessors(name, options)
        self
      end

      # https://www.leighhalliday.com/ruby-metaprogramming-creating-methods
      def create_accessors(name, options)
        define_method(name) do # Define get method
          instance_variable_get("@#{name}")
        end

        define_method("#{name}=") do |value| # Define set method
          instance_variable_set("@#{name}", coerce(value, options[:type]))
        end
      end
    end
  end
end
