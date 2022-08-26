require 'rails_helper'

describe Task, type: :model do

  describe '#validation' do
    let(:user) { FactoryBot.create(:user) }
    let(:params) { { title: 'title', content: 'content', label: 'label', user_id: user.id } }

    context 'title' do

      it '正常' do
        task = Task.new(params)
        expect(task).to be_valid
      end

      it '0文字' do
        task = Task.new(params)
        task.title = ''
        expect(task).to be_invalid
      end

      it '128文字' do
        task = Task.new(params)
        task.title =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '1234567890123456789012345678'
        expect(task).to be_valid
      end

      it '129文字' do
        task = Task.new(params)
        task.title =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234567890123456789'
        expect(task).to be_invalid
      end

    end

    context 'content' do

      it '正常' do
        task = Task.new(params)
        expect(task).to be_valid
      end

      it '0文字' do
        task = Task.new(params)
        task.content = ''
        expect(task).to be_invalid
      end

      it '1024文字' do
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

      it '1025文字' do
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

    context 'label' do

      it '正常' do
        task = Task.new(params)
        expect(task).to be_valid
      end

      it '0文字' do
        task = Task.new(params)
        task.label = ''
        expect(task).to be_invalid
      end

      it '64文字' do
        task = Task.new(params)
        task.label =
          '12345678901234567890123456789012345678901234567890'\
          '12345678901234'
        expect(task).to be_valid
      end

      it '65文字' do
        task = Task.new(params)
        task.label =
        '12345678901234567890123456789012345678901234567890'\
        '123456789012345'
      expect(task).to be_invalid
      end

    end

  end

  describe '#search' do
    let!(:task_A1) { FactoryBot.create(:task, title: 'titleA', status: '1') }
    let!(:task_A2) { FactoryBot.create(:task, title: 'titleA', status: '2') }
    let!(:task_B1) { FactoryBot.create(:task, title: 'titleB', status: '1') }
    let!(:task_B2) { FactoryBot.create(:task, title: 'titleB', status: '2') }

    context 'word、statusへ空白を指定して検索' do

      it '全て取得されること' do
        expect(Task.search('', '').size).to eq(4)
      end

    end

    context 'wordのみ指定して検索（word:"titleA" ※完全一致）' do

      it '2件取得されること' do
        expect(Task.search('titleA', '').size).to eq(2)
      end

      it '全て「titleA」がタイトルに含まれること' do
        word = 'titleA'
        Task.search(word, '').each do |task|
          expect(task.title.include?(word)).to be(true)
        end
      end

    end

    context 'wordのみ指定して検索（word:"A" ※部分一致）' do

      it '2件取得されること' do
        expect(Task.search('A', '').size).to eq(2)
      end

      it '全て「A」がタイトルに含まれること' do
        word = 'A'
        Task.search(word, '').each do |task|
          expect(task.title).to be_include(word)
        end
      end

    end

    context 'statusのみ指定して検索（status:"1"）' do

      it '2件取得されること' do
        expect(Task.search('', Task.statuses[:not_started]).size).to eq(2)
      end

      it '全てステータスが未着手であること' do
        status = Task.statuses[:not_started]
        Task.search('', status).each do |task|
          expect(Task.statuses[task.status]).to be(status)
        end
      end

    end

    context 'word、statusを指定して検索（word:"A"、status:"1"）' do

      it '1件取得されること' do
        expect(Task.search('A', Task.statuses[:not_started]).size).to eq(1)
      end

      it '全て「A」がタイトルに含まれ、ステータスが未着手であること' do
        status = Task.statuses[:not_started]
        Task.search('A', status).each do |task|
          expect(task.title.include?('A') && Task.statuses[task.status] == status).to be(true)
        end
      end

    end

  end

end
