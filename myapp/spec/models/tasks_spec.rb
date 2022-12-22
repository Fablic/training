require 'rails_helper'

describe Task, type: :model do
  describe 'validations' do
    subject { build(:task) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:due_date) }
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
end
