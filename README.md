# DataSteroid

DataSteroid is an ODM (Object-Document-Mapper) framework for Google Datastore in Ruby based in Mongoid.

Install
-------
```sh
gem build data_steroid
gem install data_steroid-<version>.gem
```
or
```ruby
gem 'data_steroid', '~> 0.4.0', git: 'https://github.com/b2beauty/data_steroid'
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
  include DataSteroid::Entity # inject entity behaviour
  include DataSteroid::Timestamps # add created and updated properties

  kind 'Product' # Datastore Kind

  property :barcode
  property :name
  property :price

  validates :barcode, :name, :price, presence: true
end

# Example

# Create and save
product = Product.new { barcode: '7891231231234', name: 'iPhone 7', price: 3000.00 }
product.save

# Find and update
product = Product.find 1
product.properties = name: 'iPhone 7', price: 3000.00
product.barcode = '7891231231234'
product.save

# Fetch all
all_products = Product.all

# Fetch all
all_products_ordered = Product.fetch Product.query.order('name', :asc)

# Fetch all
iphones = Product.fetch Product.query.where('name', '=', 'iPhone 7')

```
