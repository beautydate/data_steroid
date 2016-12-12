module DatastoreDevelopementHelper
  def clear_datastore_kind(kind)
    kind.all { |k| k.delete }
  end
end

RSpec.configure do |c|
  c.include DatastoreDevelopementHelper
end
