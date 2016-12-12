class ProductTest
  include DataSteroid::Entity # inject entity behaviour
  include DataSteroid::Timestamps # add created and updated properties

  kind 'ProductTest' # Datastore Kind

  property :name, String # optional type
  property :price, Float # optional type
end

RSpec.describe ProductTest, type: :model do
  before :each do
    # TODO: clear database before suite
    clear_datastore_kind(ProductTest)
  end

  it 'Save' do
    p = ProductTest.new(name: 'iPhone XYZ', price: 1.2)
    expect(p.save).to be_truthy

    res = ProductTest.fetch ProductTest.query.where('name', '=', 'iPhone XYZ')
    expect(res.count).to eq(1)

    p1 = res.first
    expect(p1.name).to eq(p.name)
    expect(p1.price).to eq(p.price)
  end
end
