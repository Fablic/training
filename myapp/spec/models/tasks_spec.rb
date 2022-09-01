require 'rails_helper'

describe Task, type: :model do
  describe '#validation' do
    describe 'title' do
      context '0文字' do
        subject(:task) { FactoryBot.build(:task, title: '') }

        it { is_expected.to be_invalid }
      end

      context '1文字' do
        subject(:task) { FactoryBot.build(:task, title: '1') }

        it { is_expected.to be_valid }
      end

      context '128文字' do
        subject(:task) { FactoryBot.build(:task, title: '1' * 128) }

        it { is_expected.to be_valid }
      end

      context '129文字' do
        subject(:task) { FactoryBot.build(:task, title: '1' * 129) }

        it { is_expected.to be_invalid }
      end
    end

    describe 'content' do
      context '0文字' do
        subject(:task) { FactoryBot.build(:task, content: '') }

        it { is_expected.to be_invalid }
      end

      context '1文字' do
        subject(:task) { FactoryBot.build(:task, content: '1') }

        it { is_expected.to be_valid }
      end

      context '1024文字' do
        subject(:task) { FactoryBot.build(:task, content: '1' * 1024) }

        it { is_expected.to be_valid }
      end

      context '1025文字' do
        subject(:task) { FactoryBot.build(:task, content: '1' * 1025) }

        it { is_expected.to be_invalid }
      end
    end

    describe 'label' do
      context '0文字' do
        subject(:task) { FactoryBot.build(:task, label: '') }

        it { is_expected.to be_invalid }
      end

      context '1文字' do
        subject(:task) { FactoryBot.build(:task, label: '1') }

        it { is_expected.to be_valid }
      end

      context '64文字' do
        subject(:task) { FactoryBot.build(:task, label: '1' * 64) }

        it { is_expected.to be_valid }
      end

      context '65文字' do
        subject(:task) { FactoryBot.build(:task, label: '1' * 65) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
