require 'rails_helper'

describe Task, type: :model do
  describe '#validation' do
    describe 'タイトル' do
      context '0文字' do
        subject(:task) { FactoryBot.build(:task, title: '') }

        it { is_expected.to be_invalid }
      end

      context '1文字' do
        subject(:task) { FactoryBot.build(:task, title: '1') }

        it { is_expected.to be_valid }
      end

      context '30文字' do
        subject(:task) { FactoryBot.build(:task, title: '1' * 30) }

        it { is_expected.to be_valid }
      end

      context '31文字' do
        subject(:task) { FactoryBot.build(:task, title: '1' * 31) }

        it { is_expected.to be_invalid }
      end
    end

    describe '説明' do
      context '0文字' do
        subject(:task) { FactoryBot.build(:task, description: '') }

        it { is_expected.to be_invalid }
      end

      context '1文字' do
        subject(:task) { FactoryBot.build(:task, description: '1') }

        it { is_expected.to be_valid }
      end

      context '100文字' do
        subject(:task) { FactoryBot.build(:task, description: '1' * 100) }

        it { is_expected.to be_valid }
      end

      context '101文字' do
        subject(:task) { FactoryBot.build(:task, description: '1' * 101) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
