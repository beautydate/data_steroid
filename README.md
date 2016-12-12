# DataSteroid

DataSteroid is an ODM (Object-Document-Mapper) framework for Google Datastore in Ruby based in Mongoid.

Install
-------
```ruby
gem 'data_steroid'
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
  property :name, String # optional type
  property :price, Float # optional type

  validates :barcode, :name, :price, presence: true
end

# Example

# Create and save
product = Product.new(barcode: '7891231231234', name: 'iPhone 7', price: 3000.00)
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

# Parent/child

p1 = Product.new(barcode: '1233', name: 'Xyz', price: 2000).tap { |x| x.save }
p2 = Product.new(barcode: '1233.1', name: 'Xyz White', price: 1900, parent: p1).tap { |x| x.save }

xyz = Product.fetch Product.query.ancestor(p1.as_parent_key).where('price', '>', '1800')

```

Develop
-------

```sh
gem build data_steroid
gem install data_steroid-<version>.gem
```

Develop with docker
-------------------
```
docker-compose run --rm data_steroid bash
rspec
```
