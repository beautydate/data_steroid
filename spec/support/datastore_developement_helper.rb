module DatastoreDevelopementHelper
  def clear_datastore_kind(kind)
    kind.all.each { |k| k.delete }
  end
end

RSpec.configure do |c|
  c.include DatastoreDevelopementHelper
end
