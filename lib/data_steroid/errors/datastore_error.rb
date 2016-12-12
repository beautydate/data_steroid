module DataSteroid
  module Errors
    class DatastoreError < StandardError
    end

    class InvalidRecord < DatastoreError
    end
  end
end
