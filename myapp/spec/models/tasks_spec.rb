require 'rails_helper'

describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:due_date) }
  end

  describe 'associations' do
    it { should have_many(:taggings) }
    it { should have_many(:tags) }

    describe '#limited_tags' do
      let(:task) { create(:task) }

      context 'when associated tags amount is within limit' do
        before { task.tag_list = 'tag1, tag2, tag3, tag4, tag5' }

        it 'return all tags' do
          expect(task.limited_tags.count).to eq(5)
        end
      end

      context 'when associated tags amount is over limit' do
        before { task.tag_list = 'tag1, tag2, tag3, tag4, tag5, tag6' }

        it 'return limited tags' do
          expect(task.limited_tags.count).to eq(5)
        end
      end
    end
  end

  describe '.tagged_with' do
    before do
      task = create(:task)
      task.tag_list = 'tag1, tag2'
    end
    context 'when tasks with tag name exists' do
      let(:tag_name) { 'tag1' }

      it 'returns correct tasks' do
        result = Task.tagged_with(tag_name)

        expect(result.count).to eq(1)
      end
    end

    context 'when tasks with tag name does not exist' do
      let(:tag_name) { 'tag3' }

      it 'returns correct tasks' do
        result = Task.tagged_with(tag_name)

        expect(result.count).to eq(0)
      end
    end
  end

  describe 'status' do
    describe 'default status' do
      it 'set default status be unstarted' do
        expect(Task.new.status).to eq('unstarted')
      end
    end

    describe 'when transition status acceptable' do
      it 'updates status successfully' do
        task = create(:task)
        task.start!
        expect(task.reload.status).to eq('started')
      end
    end

    describe 'when transition status not acceptable' do
      it 'does not update status' do
        task = create(:task, :completed)
        expect(task).to_not allow_event :start
      end
    end
  end

  describe 'scopes' do
    describe 'by_title' do
      let(:key_word) { 'key' }

      before do
        create_list(:task, 2, title: 'copy the keys')
        create(:task)
      end
      it 'returns records with passed in keywords in title' do
        expect(Task.by_title(key_word).size).to eq(2)
      end
    end
  end
end
