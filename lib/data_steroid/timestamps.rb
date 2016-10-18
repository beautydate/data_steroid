require 'time'

module DataSteroid
  # Define behaviour to created_at and updated_at data
  module Timestamps
    extend ActiveSupport::Concern

    included do
      property :created_at, Time, default: DateTime.now
      property :updated_at, time

      before_save :set_updated_at

      def set_updated_at
        self.updated_at = DateTime.now
      end
    end
  end
end
