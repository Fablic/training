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
end
