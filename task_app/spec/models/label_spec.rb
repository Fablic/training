# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe 'validation' do
    let!(:user) { FactoryBot.create(:user) }

    context '正常値のとき' do
      it { expect(FactoryBot.build(:label, user: user)).to be_valid }
    end

    describe 'ラベル名' do
      let!(:label) { FactoryBot.build(:label, name: name, user: user) }
      subject { label }

      context '空のとき' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context '1文字のとき' do
        let(:name) { 'a' }
        it { is_expected.to be_valid }
      end

      context '10文字のとき' do
        let(:name) { 'a' * 10 }
        it { is_expected.to be_valid }
      end

      context '11文字のとき' do
        let(:name) { 'a' * 11 }
        it { is_expected.to be_invalid }
      end

      context '登録済みのラベル名のとき' do
        let!(:duplicate_label) { FactoryBot.create(:label, user: user) }
        let(:name) { duplicate_label.name }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe 'has_many :task_labels, dependent: :delete_all' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:label1) { FactoryBot.create(:label, name: 'ラベル1', user: user) }
    let!(:label2) { FactoryBot.create(:label, name: 'ラベル2', user: user) }
    let!(:task) { FactoryBot.create(:task, labels: [label1, label2], user: user) }

    context 'ラベル2を削除したとき' do
      it 'タスクからラベル2が削除される' do
        expect(Label.count).to eq 2
        expect(task.labels.exists?(name: label2.name)).to eq true
        label2.destroy
        expect(Label.count).to eq 1
        expect(task.labels.exists?(name: label2.name)).to eq false
      end
    end
  end
end
