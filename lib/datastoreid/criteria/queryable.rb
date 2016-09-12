module Datastoreid
  module Criteria
    # Defines behaviour for query operations.
    module Queryable
      extend ActiveSupport::Concern

      class_methods do
        def query
          datastore.query(kind)
        end

        def run(query)
          result = datastore.run query
          new(result.first) if result.count == 1
        end

        def fetch(query)
          result = datastore.run query
          if result.count > 0
            result.map { |element| new(element) }
          else
            []
          end
        end

        def all
          fetch query
        end
      end
    end
  end
end
