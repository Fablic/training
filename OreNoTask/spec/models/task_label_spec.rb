# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  let(:user) { create(:user, name: 'HanakoRakuten', password: 'hanakopass', privilege: :user) }
  let(:task) { create(:task, name: 'task', description: 'desc', status: :wip, start_at: '2021-09-01 10:00', due_date_at: '2021-09-02 10:00', user_id: user.id) }
  let(:label) { create(:label, name: 'label') }

  let(:task_id) { task.id }
  let(:label_id) { label.id }

  describe '正常系' do
    subject { described_class.new(task_id: task_id, label_id: label_id) }

    context '全項目入力' do
      it { is_expected.to be_valid }
    end
  end

  describe 'バリデーションのテスト' do
    subject { described_class.new(task_id: task_id, label_id: label_id) }

    describe 'task_idカラム' do
      context '空欄' do
        let(:task_id) { nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'label_idカラム' do
      context '空欄' do
        let(:label_id) { nil }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
