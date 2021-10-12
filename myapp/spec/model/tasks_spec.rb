RSpec.describe Task, type: :model do
  # 検索
  describe '検索'  do
    before do
      @task = FactoryBot.create(:task, name:'test',status:'new')
    end
    describe '名称検索' do
      it '完全一致' do
        form = SearchForm.new(name:'test')
        expect(form.exec_search(1)).to include(@task)
      end
      it '前方一致' do
        form = SearchForm.new(name:'te')
        expect(form.exec_search(1)).to include(@task)
      end
      it '後方一致' do
        form = SearchForm.new(name:'st')
        expect(form.exec_search(1)).to include(@task)
      end
      it '部分一致' do
        form = SearchForm.new(name:'es')
        expect(form.exec_search(1)).to include(@task)
      end
    end
    describe '状態検索' do
      it '状態一致' do
        form = SearchForm.new(status:'new')
        expect(form.exec_search(1)).to include(@task)
      end
    end

    describe 'ヒットしない場合' do
      it '名称ヒットなし' do
        form = SearchForm.new(name:'sample')
        expect(form.exec_search(1)).to be_empty
      end
      it '名称ヒットあり、状態ヒットなし(and条件確認）' do
        form = SearchForm.new(name:'test',status:'complete')
        expect(form.exec_search(1)).to be_empty
      end
    end
  end
end
