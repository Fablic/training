require 'rails_helper'

RSpec.describe Task, type: :model do
  example '作成できるか' do
    task = FactoryBot.build(:task)
    expect(task).to be_valid
  end

  example 'タイトルが存在しないと無効' do
    task_notitle = FactoryBot.build(:task, :no_title)
    task_notitle.valid?
    expect(task_notitle.errors[:title]).to include I18n.t('errors.messages.blank')
  end

  example 'タイトルが256文字以上だと無効' do
    task_longtitle = FactoryBot.build(:task, :long_title)
    task_longtitle.valid?
    expect(task_longtitle.errors[:title]).to include I18n.t('errors.messages.too_long', :count => 255)
  end

  describe '#search' do
    let!(:task_hoge) {
      FactoryBot.create(:task, title: 'hogehoge')
    }
    let!(:task_fuga) {
      FactoryBot.create(:task, title: 'fugafuga')
    }
    let!(:task_complete) {
      FactoryBot.create(:task, :status_completed)
    }

    example 'キーワード、ステータスを指定しない時は全て返す' do
      search_noword = Task.search('', '')
      expect(search_noword.length).to eq 3
    end

    example 'タイトルが部分一致する配列を返す' do
      search_title = Task.search('hoge', '0')
      expect(search_title).to include(task_hoge) 
      expect(search_title.length).to eq 1
    end

    example 'ステータスが一致する配列を返す' do
      search_complete = Task.search('', '2')
      expect(search_complete).to include(task_complete) 
      expect(search_complete.length).to eq 1
    end
    
  end

end
