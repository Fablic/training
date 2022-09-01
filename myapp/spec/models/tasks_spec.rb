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

  describe '#search' do
    let!(:titleA1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started') }
    let!(:titleA2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress') }
    let!(:titleB1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started') }
    let!(:titleB2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress') }

    context 'word、statusが空白' do
      subject(:title_list) { Task.search('', '').pluck(:title) }

      it { is_expected.to include('titleA1') }
      it { is_expected.to include('titleA2') }
      it { is_expected.to include('titleB1') }
      it { is_expected.to include('titleB2') }
    end

    context 'wordのみ指定 ※完全一致' do
      subject(:title_list) { Task.search('titleA1', '').pluck(:title) }

      it { is_expected.to include('titleA1') }
      it { is_expected.not_to include('titleA2') }
      it { is_expected.not_to include('titleB1') }
      it { is_expected.not_to include('titleB2') }
    end

    context 'wordのみ指定 ※部分一致' do
      subject(:title_list) { Task.search('A', '').pluck(:title) }

      it { is_expected.to include('titleA1') }
      it { is_expected.to include('titleA2') }
      it { is_expected.not_to include('titleB1') }
      it { is_expected.not_to include('titleB2') }
    end

    context 'statusのみ指定' do
      subject(:title_list) { Task.search('', '1').pluck(:title) }

      it { is_expected.to include('titleA1') }
      it { is_expected.not_to include('titleA2') }
      it { is_expected.to include('titleB1') }
      it { is_expected.not_to include('titleB2') }
    end

    context 'word、statusを指定' do
      subject(:title_list) { Task.search('A', '1').pluck(:title) }

      it { is_expected.to include('titleA1') }
      it { is_expected.not_to include('titleA2') }
      it { is_expected.not_to include('titleB1') }
      it { is_expected.not_to include('titleB2') }
    end
  end
end
