# Datastoreid

Datastoreid is an ODM (Object-Document-Mapper) framework for Google Datastore in Ruby.

Install
-------
```sh
gem build datastoreid-<version>.gem
gem install datastoreid-<version>.gem
```
or
```ruby
gem 'datastoreid', , :git => 'git://github.com/fabiotomio/datastoreid.git'
```

Configure
---------
```sh
export DATASTORE_EMULATOR_HOST_PATH=datastore:8181/datastore
export DATASTORE_EMULATOR_HOST=datastore:8181
export DATASTORE_DATASET=<project-id>
export DATASTORE_PROJECT_ID=<project-id>
```

Use
-------
```ruby
# Define product model product.rb
class Product
  include Datastore::Entity # inject entity behaviour
  include Datastore::Timestamps # add created and updated properties

  kind 'Product' # Datastore Kind

  property :barcode 
  property :name
  property :price

  validates :barcode, :name, :price, presence: true
end
```