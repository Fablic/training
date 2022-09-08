require 'rails_helper'

describe Task, type: :model do
  describe '#validation' do
    describe 'タイトル' do
      context 'nil' do
        subject(:task) { FactoryBot.build(:task, title: nil) }

        it { is_expected.to be_invalid }
      end

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
      context 'nil' do
        subject(:task) { FactoryBot.build(:task, description: nil) }

        it { is_expected.to be_invalid }
      end

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

  describe '#scope' do
    describe 'where_title' do
      context '完全一致' do
        let!(:task) { FactoryBot.create(:task, title: 'あいうえお') }

        it '検索結果が存在すること' do
          expect(Task.where_title('あいうえお').count).to eq 1
        end
      end

      context '前方一致' do
        let!(:task) { FactoryBot.create(:task, title: 'あいうえお') }

        it '検索結果が存在すること' do
          expect(Task.where_title('あい').count).to eq 1
        end
      end

      context '後方一致' do
        let!(:task) { FactoryBot.create(:task, title: 'あいうえお') }

        it '検索結果が存在すること' do
          expect(Task.where_title('えお').count).to eq 1
        end
      end

      context '中央一致' do
        let!(:task) { FactoryBot.create(:task, title: 'あいうえお') }

        it '検索結果が存在すること' do
          expect(Task.where_title('いうえ').count).to eq 1
        end
      end

      context '不一致' do
        let!(:task) { FactoryBot.create(:task, title: 'あいうえお') }

        it '検索結果が存在しないこと' do
          expect(Task.where_title('TEST')).to be_empty
        end
      end

      context '空文字' do
        let!(:task) { FactoryBot.create(:task, title: 'あいうえお') }

        it '検索結果が存在すること' do
          expect(Task.where_title('').count).to eq 1
        end
      end

      context 'nil' do
        let!(:task) { FactoryBot.create(:task, title: 'あいうえお') }

        it '検索結果が存在すること' do
          expect(Task.where_title(nil).count).to eq 1
        end
      end
    end

    describe 'where_status' do
      context '一致' do
        let!(:task) { FactoryBot.create(:task, status: Task.statuses[:in_progress]) }

        it '検索結果が存在すること' do
          expect(Task.where_status(Task.statuses[:in_progress]).count).to eq 1
        end
      end

      context '不一致' do
        let!(:task) { FactoryBot.create(:task, status: Task.statuses[:in_progress]) }

        it '検索結果が存在しないこと' do
          expect(Task.where_status(Task.statuses[:not_started])).to be_empty
        end
      end

      context '空文字' do
        let!(:task) { FactoryBot.create(:task, status: Task.statuses[:in_progress]) }

        it '検索結果が存在すること' do
          expect(Task.where_status('').count).to eq 1
        end
      end

      context 'nil' do
        let!(:task) { FactoryBot.create(:task, status: Task.statuses[:in_progress]) }

        it '検索結果が存在すること' do
          expect(Task.where_status(nil).count).to eq 1
        end
      end
    end
  end
end
