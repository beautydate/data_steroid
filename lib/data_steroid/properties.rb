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
        if value.nil? || !type
          value
        else
          case
          when Array == type || Array === type then coerce_array(value, type)
          when Hash  == type || Hash  === type then coerce_hash(value, type)
          when type == Time  then coerce_time(value)
          else coerce_other(value, type)
          end
        end
      end

      def coerce_array(value, type)
        # type: generic Array
        if type == Array
          coerce(element, type)
        # type: Array[Something]
        elsif value.respond_to?(:map)
          value.map do |element|
            coerce(element, type[0])
          end
        else
          raise ArgumentError.new "Invalid coercion: #{value.class} => #{type}"
        end
      end

      def coerce_hash(value, type)
        # type: generic Hash
        if type == Hash
          coerce(element, type)
        # type: Hash[Something => Other thing]
        elsif value.is_a?(Hash)
          k_type, v_type = type.to_a[0]
          value.map{ |k, v| [ coerce(k, k_type), coerce(v, v_type) ] }.to_h
        else
          raise ArgumentError.new "Invalid coercion: #{value.class} => #{type}"
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
        coercer[value.class].send("to_#{type.to_s.downcase}", value)
      end
    end

    class_methods do
      protected

      def add_property(name, *args)
        options = args[-1].is_a?(Hash) ? args[-1].slice(:default) : {}
        options[:type] = args[0] if args[0]
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
