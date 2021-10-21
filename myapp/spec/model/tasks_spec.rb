RSpec.describe Task, type: :model do
  # 検索
  describe '検索' do
    before do
      @user = FactoryBot.create(:user1)
      @task = FactoryBot.create(:task, name: 'test', status: 'new', user: @user)
    end
    describe '名称検索' do
      it '完全一致' do
        form = SearchForm.new(name: 'test')
        expect(@user.searched_tasks(form, 1)).to include(@task)
      end
      it '前方一致' do
        form = SearchForm.new(name: 'te')
        expect(@user.searched_tasks(form, 1)).to include(@task)
      end
      it '後方一致' do
        form = SearchForm.new(name: 'st')
        expect(@user.searched_tasks(form, 1)).to include(@task)
      end
      it '部分一致' do
        form = SearchForm.new(name: 'es')
        expect(@user.searched_tasks(form, 1)).to include(@task)
      end
    end
    describe '状態検索' do
      it '状態一致' do
        form = SearchForm.new(status: 'new')
        expect(@user.searched_tasks(form, 1)).to include(@task)
      end
    end

    describe 'ヒットしない場合' do
      it '名称ヒットなし' do
        form = SearchForm.new(name: 'sample')
        expect(@user.searched_tasks(form, 1)).to be_empty
      end
      it '名称ヒットあり、状態ヒットなし(and条件確認）' do
        form = SearchForm.new(name: 'test', status: 'complete')
        expect(@user.searched_tasks(form, 1)).to be_empty
      end
    end
  end
end
