module DataSteroid
  # Define behaviour to created_at and updated_at data
  module Timestamps
    extend ActiveSupport::Concern

    included do
      property :created_at, default: DateTime.now
      property :updated_at

      before_save :update_updated_at

      def update_updated_at
        self.updated_at = DateTime.now
      end
    end
  end
end
