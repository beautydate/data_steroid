class ProductTest
  include DataSteroid::Entity # inject entity behaviour
  include DataSteroid::Timestamps # add created and updated properties

  kind 'ProductTest' # Datastore Kind

  property :name, String # optional type
  property :price, Float # optional type
end

RSpec.describe ProductTest, type: :model do
  let(:product) { ProductTest.new(name: 'iPhone XYZ', price: 1.2) }
  before :each do
    # TODO: clear database before suite
    clear_datastore_kind(ProductTest)
  end

  it 'saves' do
    expect(product.save).to be_truthy

    resources = ProductTest.fetch ProductTest.query.where('name', '=', 'iPhone XYZ')
    expect(resources.count).to eq(1)

    p1 = resources.first
    expect(p1.name).to eq(product.name)
    expect(p1.price).to eq(product.price)
  end

  it 'deletes' do
    product.save

    resources = ProductTest.fetch ProductTest.query.where('name', '=', 'iPhone XYZ')
    expect(resources.count).to eq(1)

    product.delete

    resources = ProductTest.fetch ProductTest.query.where('name', '=', 'iPhone XYZ')
    expect(resources.count).to eq(0)
  end

  it 'find by id' do
    product.save

    new_product = ProductTest.find(product.id)

    expect(new_product.name).to eq(product.name)
  end
end
