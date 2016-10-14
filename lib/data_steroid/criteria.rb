module DataSteroid
  # Inject behaviour for query operations.
  module Criteria
    extend ActiveSupport::Concern

    include Queryable
    include Findable
  end
end
