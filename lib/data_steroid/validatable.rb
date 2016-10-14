require 'google/cloud/datastore/entity'

module DataSteroid
  # Add validations to attributes of model.
  module Validatable
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Validations
    end
  end
end
