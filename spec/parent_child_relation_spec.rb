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
  let(:parent) { ParentEntity.new(name: 'parent 1') }

  before(:each) do
    clear_datastore_kind(ParentEntity)
    clear_datastore_kind(ChildEntity)
  end

  context 'key formation' do
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
      parent.id = 123
      expect(ChildEntity.datastore).to receive(:key).with(["ParentEntity", 123], ["ChildEntity", nil]).and_return(:child_key)

      key = ChildEntity.new(name: 'child', parent: parent).gcloud_key
      expect(key).to eq(:child_key)
    end

    it 'without parent' do
      expect(ChildEntity.datastore).to receive(:key).with([ChildEntity.kind, nil]).and_return(:child_key)

      key = ChildEntity.new(name: 'child').gcloud_key
      expect(key).to eq(:child_key)
    end
  end

  context 'integration' do
    context 'persistance' do
      before(:each) do
        parent.save
      end

      it 'persists' do
        child  = ChildEntity.new(name: 'child 1', parent: parent).tap { |e| e.save }
        child2 = ChildEntity.new(name: 'child 2').tap { |e| e.save }

        qry = ChildEntity.query.ancestor(parent.as_parent_key).where('name', '=', child.name)
        resources = ChildEntity.fetch qry
        expect(resources.count).to eq(1)
        expect(resources.first.name).to eq(child.name)
      end

      it 'deletes child from parent' do
        child  = ChildEntity.new(name: 'child to delete', parent: parent).tap { |e| e.save }

        qry = ChildEntity.query.ancestor(parent.as_parent_key).where('name', '=', child.name)
        resources = ChildEntity.fetch qry
        expect(resources.count).to eq(1)
        expect(resources.first.name).to eq(child.name)

        child.delete

        qry = ChildEntity.query.ancestor(parent.as_parent_key).where('name', '=', child.name)
        resources = ChildEntity.fetch qry
        expect(resources.count).to eq(0)

        qry = ChildEntity.query.where('name', '=', child.name)
        resources = ChildEntity.fetch qry
        expect(resources.count).to eq(0)
      end

      it 'finds child with parent by id' do
        child  = ChildEntity.create(name: 'child to find', parent: parent)

        resource = ChildEntity.find(child.id)
        expect(resource).to be_nil

        resource = ChildEntity.find(child.id, parent: parent)
        expect(child.name).to eq(resource.name)
      end
    end
  end
end
