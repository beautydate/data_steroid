class ParentEntity
  include DataSteroid::Entity # inject entity behaviour

  kind 'ParentEntity' # Datastore Kind

  property :name, String # optional type
end

class ChildEntity
  include DataSteroid::Entity # inject entity behaviour

  kind 'ChildEntity' # Datastore Kind

  property :name, String # optional type
end

RSpec.describe 'Parent/child relations' do
  context 'key formation' do
    it '#as_parent_key' do
      parent = ParentEntity.new(name: 'parent 1')
      expect(parent.respond_to?(:as_parent_key)).to be_truthy
    end

    it '#as_parent_key persisted' do
      parent = ParentEntity.new(name: 'parent 1')
      expect(parent).to receive(:persisted?).and_return(true)
      expect(parent).to receive(:gcloud_key).and_return(:key)

      expect(parent.as_parent_key).to eq(:key)
    end


    it '#as_parent_key persisted' do
      parent = ParentEntity.new(name: 'parent 1')
      expect(parent).to receive(:persisted?).and_return(false)
      expect(parent).not_to receive(:gcloud_key)

      expect { parent.as_parent_key }.to raise_error('parent not persisted')
    end
  end
end
