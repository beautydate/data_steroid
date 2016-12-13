module DatastoreDevelopementHelper
  def clear_datastore_kind(kind)
    kind.all.each(&:delete)
  end
end

RSpec.configure do |c|
  c.include DatastoreDevelopementHelper
end
