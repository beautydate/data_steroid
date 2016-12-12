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
    let(:parent) { ParentEntity.new(name: 'parent 1') }
    it '#as_parent_key' do
      expect(parent.respond_to?(:as_parent_key)).to be_truthy
    end

    it '#as_parent_key persisted' do
      expect(parent).to receive(:persisted?).and_return(true)
      expect(parent).to receive(:gcloud_key).and_return(:key)

      expect(parent.as_parent_key).to eq(:key)
    end


    it '#as_parent_key persisted' do
      expect(parent).to receive(:persisted?).and_return(false)
      expect(parent).not_to receive(:gcloud_key)

      expect { parent.as_parent_key }.to raise_error('parent not persisted')
    end

    it 'pass parent' do
      expect(parent).to receive(:persisted?).and_return(true)
      expect(parent).to receive(:gcloud_key).and_return(:parent_key)

      expect(ChildEntity.datastore).to receive(:key).with(ChildEntity.kind, nil, :parent_key).and_return(:child_key)

      key = ChildEntity.new(name: 'child', parent: parent).gcloud_key
      expect(key).to eq(:child_key)
    end

    it 'without parent' do
      expect(ChildEntity.datastore).to receive(:key).with(ChildEntity.kind, nil).and_return(:child_key)

      key = ChildEntity.new(name: 'child').gcloud_key
      expect(key).to eq(:child_key)
    end
  end
end
