require 'rails_helper'

describe Task, type: :model do

  describe '1 validation' do
    let(:params) { { title: 'title', content: 'content', label: 'label' } }

    context '1-1 title' do

      it '1-1-1 正常' do
        task = Task.new(params)
        expect(task).to be_valid
      end

      it '1-1-2 0文字' do
        task = Task.new(params)
        task.title = ''
        expect(task).to be_invalid
      end

      it '1-1-3 128文字' do
        task = Task.new(params)
        task.title =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '1234567890123456789012345678'
        expect(task).to be_valid
      end

      it '1-1-4 129文字' do
        task = Task.new(params)
        task.title =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789'
        expect(task).to be_invalid
      end

    end

    context '1-2 content' do

      it '1-2-1 正常' do
        task = Task.new(params)
        expect(task).to be_valid
      end
  
      it '1-2-2 0文字' do
        task = Task.new(params)
        task.content = ''
        expect(task).to be_invalid
      end
  
      it '1-2-3 1024文字' do
        task = Task.new(params)
        task.content =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '123456789012345678901234'
        expect(task).to be_valid
      end
  
      it '1-2-4 1025文字' do
        task = Task.new(params)
        task.content =
        task.content =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '1234567890123456789012345'
        expect(task).to be_invalid
      end
  
    end
  
    context '1-3 label' do

      it '1-3-1 正常' do
        task = Task.new(params)
        expect(task).to be_valid
      end

      it '1-3-2 0文字' do
        task = Task.new(params)
        task.label = ''
        expect(task).to be_invalid
      end

      it '1-3-3 64文字' do
        task = Task.new(params)
        task.label =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234'
        expect(task).to be_valid
      end

      it '1-3-4 65文字' do
        task = Task.new(params)
        task.label =
        '12345678901234567890123456789012345678901234567890'\
        '123456789012345'
      expect(task).to be_invalid
      end

    end

  end

  describe '2 search' do
    let!(:task_A1) { FactoryBot.create(:task_search_test_A1) }
    let!(:task_A2) { FactoryBot.create(:task_search_test_A2) }
    let!(:task_B1) { FactoryBot.create(:task_search_test_B1) }
    let!(:task_B2) { FactoryBot.create(:task_search_test_B2) }

    context '2-1 word、statusへ空白を指定して検索' do

      it '2-1-1 全て取得されること' do
        expect(Task.search('', '').size).to eq(4)
      end

    end

    context '2-2 wordのみ指定して検索（word:"titleA" ※完全一致）' do

      it '2-2-1 2件取得されること' do
        expect(Task.search('titleA', '').size).to eq(2)
      end

      it '2-2-2 全て「titleA」がタイトルに含まれること' do
        word = 'titleA'
        Task.search(word, '').each do |task|
          expect(task.title.include?(word)).to be(true)
        end
      end

    end

    context '2-3 wordのみ指定して検索（word:"A" ※部分一致）' do

      it '2-3-1 2件取得されること' do
        expect(Task.search('A', '').size).to eq(2)
      end

      it '2-3-2 全て「A」がタイトルに含まれること' do
        word = 'A'
        Task.search(word, '').each do |task|
          expect(task.title).to be_include(word)
        end
      end

    end

    context '2-4 statusのみ指定して検索（status:"1"）' do

      it '2-4-1 2件取得されること' do
        expect(Task.search('', Task.statuses[:not_started]).size).to eq(2)
      end

      it '2-4-2 全てステータスが未着手であること' do
        status = Task.statuses[:not_started]
        Task.search('', status).each do |task|
          expect(Task.statuses[task.status]).to be(status)
        end
      end

    end

    context '2-5 word、statusを指定して検索（word:"A"、status:"1"）' do

      it '2-5-1 1件取得されること' do
        expect(Task.search('A', Task.statuses[:not_started]).size).to eq(1)
      end

      it '2-5-2 全て「A」がタイトルに含まれ、ステータスが未着手であること' do
        status = Task.statuses[:not_started]
        Task.search('A', status).each do |task|
          expect(task.title.include?('A') && Task.statuses[task.status] == status).to be(true)
        end
      end

    end

  end

end
