require 'virtus'

module DataSteroid
  # Define behaviour to properties of entity.
  module Properties
    extend ActiveSupport::Concern

    included do
      include Virtus.model

      class << self
        alias_method :property, :attribute
      end

      alias_method :properties, :attributes

      attribute :id # Default attribute
    end

    class_methods do
      def properties_names
        attribute_set.map{ |s| s.instance_variable_name.split('@')[1].to_sym }
      end
    end
  end
end
