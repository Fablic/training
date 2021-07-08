# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe '#valid?' do
    subject { build(:label, params) }
    let(:params) { { name: name } }

    context 'valid' do
      let(:name) { Faker::Alphanumeric.alphanumeric(number: 5) }
      it { is_expected.to be_valid }
    end

    context 'nil name' do
      let(:name) { nil }

      it { is_expected.to_not be_valid }
    end

    context 'more then 10 characters' do
      let(:name) { Faker::Alphanumeric.alphanumeric(number: 11) }

      it { is_expected.to_not be_valid }
    end
  end

  describe '#ensure_task_count' do
    let(:label) { create(:label) }

    context 'when have task' do
      before {
        create(:task, label_ids: [label.id])
      }
      it 'label can not destroy' do
        expect(label.tasks.count).to eq(1)
        expect { label.destroy }.to change(Label, :count).by(0)
        expect(label.errors.messages[:base]).to include('タスクが存在しているので削除できません')
      end
    end

    context 'when have task' do
      it 'label can not destroy' do
        expect(label.tasks.count).to eq(0)
        expect { label.destroy }.to change(Label, :count).by(-1)
        expect(label.errors.messages[:base]).not_to include('タスクが存在しているので削除できません')
      end
    end
  end
end
