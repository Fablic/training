require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'Association' do
    let(:association) { described_class.reflect_on_association(target) }

    context '対Taskテーブルの場合' do
      let(:target) { :tasks }

      it '関連付けが「has_many」であること' do
        expect(association.class_name).to eq 'Task'
        expect(association.macro).to eq :has_many
      end
    end

    context '対Tasks_labelテーブルの場合' do
      let(:target) { :tasks_labels }

      it '関連付けが「has_many」であること' do
        expect(association.class_name).to eq 'TasksLabel'
        expect(association.macro).to eq :has_many
      end
    end
  end
end
