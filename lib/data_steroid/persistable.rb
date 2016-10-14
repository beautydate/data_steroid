module DataSteroid
  # Inject behaviour for poersistation operations.
  module Persistable
    extend ActiveSupport::Concern

    include Savable
    include Deletable
    include Creatable
  end
end
