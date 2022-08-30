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
    let!(:user_one) { FactoryBot.create(:user) }
    let!(:titleA1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user_one.id) }
    let!(:titleA2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user_one.id) }
    let!(:titleB1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user_one.id) }
    let!(:titleB2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user_one.id) }

    let!(:user_two) { FactoryBot.create(:user) }
    let!(:titleA3) { FactoryBot.create(:task, title: 'titleA3', status: 'not_started', user_id: user_two.id) }
    let!(:titleA4) { FactoryBot.create(:task, title: 'titleA4', status: 'in_progress', user_id: user_two.id) }
    let!(:titleB3) { FactoryBot.create(:task, title: 'titleB3', status: 'not_started', user_id: user_two.id) }
    let!(:titleB4) { FactoryBot.create(:task, title: 'titleB4', status: 'in_progress', user_id: user_two.id) }

    context 'user_id、word、statusが空白' do
      let(:title_list) { Task.search(nil, '', '').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていること' do
        expect(title_list).to include('titleA2')
      end

      it 'titleB1が取得されていること' do
        expect(title_list).to include('titleB1')
      end

      it 'titleB2が取得されていること' do
        expect(title_list).to include('titleB2')
      end

      it 'titleA3が取得されていること' do
        expect(title_list).to include('titleA3')
      end

      it 'titleA4が取得されていること' do
        expect(title_list).to include('titleA4')
      end

      it 'titleB3が取得されていること' do
        expect(title_list).to include('titleB3')
      end

      it 'titleB4が取得されていること' do
        expect(title_list).to include('titleB4')
      end
    end

    context 'statusのみ指定' do
      let(:title_list) { Task.search(nil, '', '1').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていないこと' do
        expect(title_list).not_to include('titleA2')
      end

      it 'titleB1が取得されていること' do
        expect(title_list).to include('titleB1')
      end

      it 'titleB2が取得されていないこと' do
        expect(title_list).not_to include('titleB2')
      end

      it 'titleA3が取得されていること' do
        expect(title_list).to include('titleA3')
      end

      it 'titleA4が取得されていないこと' do
        expect(title_list).not_to include('titleA4')
      end

      it 'titleB3が取得されていること' do
        expect(title_list).to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end

    context 'wordのみ指定 ※完全一致' do
      let(:title_list) { Task.search(nil, 'titleA1', '').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていないこと' do
        expect(title_list).not_to include('titleA2')
      end

      it 'titleB1が取得されていないこと' do
        expect(title_list).not_to include('titleB1')
      end

      it 'titleB2が取得されていないこと' do
        expect(title_list).not_to include('titleB2')
      end

      it 'titleA3が取得されていないこと' do
        expect(title_list).not_to include('titleA3')
      end

      it 'titleA4が取得されていないこと' do
        expect(title_list).not_to include('titleA4')
      end

      it 'titleB3が取得されていないこと' do
        expect(title_list).not_to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end

    context 'wordのみ指定 ※部分一致' do
      let(:title_list) { Task.search(nil, 'A', '').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていること' do
        expect(title_list).to include('titleA2')
      end

      it 'titleB1が取得されていないこと' do
        expect(title_list).not_to include('titleB1')
      end

      it 'titleB2が取得されていないこと' do
        expect(title_list).not_to include('titleB2')
      end

      it 'titleA3が取得されていること' do
        expect(title_list).to include('titleA3')
      end

      it 'titleA4が取得されていること' do
        expect(title_list).to include('titleA4')
      end

      it 'titleB3が取得されていないこと' do
        expect(title_list).not_to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end

    context 'user_idのみ指定' do
      let(:title_list) { Task.search(user_one.id, '', '').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていること' do
        expect(title_list).to include('titleA2')
      end

      it 'titleB1が取得されていること' do
        expect(title_list).to include('titleB1')
      end

      it 'titleB2が取得されていること' do
        expect(title_list).to include('titleB2')
      end

      it 'titleA3が取得されていないこと' do
        expect(title_list).not_to include('titleA3')
      end

      it 'titleA4が取得されていないこと' do
        expect(title_list).not_to include('titleA4')
      end

      it 'titleB3が取得されていないこと' do
        expect(title_list).not_to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end

    context 'word、statusを指定' do
      let(:title_list) { Task.search(nil, 'A', '1').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていないこと' do
        expect(title_list).not_to include('titleA2')
      end

      it 'titleB1が取得されていないこと' do
        expect(title_list).not_to include('titleB1')
      end

      it 'titleB2が取得されていないこと' do
        expect(title_list).not_to include('titleB2')
      end

      it 'titleA3が取得されていること' do
        expect(title_list).to include('titleA3')
      end

      it 'titleA4が取得されていないこと' do
        expect(title_list).not_to include('titleA4')
      end

      it 'titleB3が取得されていないこと' do
        expect(title_list).not_to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end

    context 'user_id、wordを指定' do
      let(:title_list) { Task.search(user_one.id, 'A', '').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていること' do
        expect(title_list).to include('titleA2')
      end

      it 'titleB1が取得されていないこと' do
        expect(title_list).not_to include('titleB1')
      end

      it 'titleB2が取得されていないこと' do
        expect(title_list).not_to include('titleB2')
      end

      it 'titleA3が取得されていないこと' do
        expect(title_list).not_to include('titleA3')
      end

      it 'titleA4が取得されていること' do
        expect(title_list).not_to include('titleA4')
      end

      it 'titleB3が取得されていないこと' do
        expect(title_list).not_to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end

    context 'user_id、statusを指定' do
      let(:title_list) { Task.search(user_one.id, '', '1').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていないこと' do
        expect(title_list).not_to include('titleA2')
      end

      it 'titleB1が取得されていること' do
        expect(title_list).to include('titleB1')
      end

      it 'titleB2が取得されていないこと' do
        expect(title_list).not_to include('titleB2')
      end

      it 'titleA3が取得されていないこと' do
        expect(title_list).not_to include('titleA3')
      end

      it 'titleA4が取得されていないこと' do
        expect(title_list).not_to include('titleA4')
      end

      it 'titleB3が取得されていないこと' do
        expect(title_list).not_to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end

    context 'user_id、word、statusを指定' do
      let(:title_list) { Task.search(user_one.id, 'A', '1').pluck(:title) }

      it 'titleA1が取得されていること' do
        expect(title_list).to include('titleA1')
      end

      it 'titleA2が取得されていないこと' do
        expect(title_list).not_to include('titleA2')
      end

      it 'titleB1が取得されていないこと' do
        expect(title_list).not_to include('titleB1')
      end

      it 'titleB2が取得されていないこと' do
        expect(title_list).not_to include('titleB2')
      end

      it 'titleA3が取得されていないこと' do
        expect(title_list).not_to include('titleA3')
      end

      it 'titleA4が取得されていないこと' do
        expect(title_list).not_to include('titleA4')
      end

      it 'titleB3が取得されていないこと' do
        expect(title_list).not_to include('titleB3')
      end

      it 'titleB4が取得されていないこと' do
        expect(title_list).not_to include('titleB4')
      end
    end
  end
end
