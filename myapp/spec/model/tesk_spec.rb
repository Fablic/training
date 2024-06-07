require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Validations' do
    context 'When using valid data' do
      it 'is valid when title/details is within their maximum length' do
        task = Task.new(title: '全' * 100, details: '角' * 1000, status: :in_progress, priority: :low)
        expect(task).to be_valid
        expect(task.title).to eq('全' * 100)
        expect(task.details).to eq('角' * 1000)
      end

      it 'sets default enums if not provided' do
        task = Task.new(title: 'Valid Title', details: 'Valid details')
        expect(task).to be_valid
        expect(task.status).to eq(:not_started.to_s)
        expect(task.priority).to eq(:middle.to_s)
      end
    end

    context 'When using invalid data' do
      it 'sets errors.messages.blank' do
        task = Task.create(title: ' ', details: 'Valid details', status: nil, priority: nil)
        expect(task).to_not be_valid
        expect(task.errors[:title]).to include(I18n.t('activerecord.errors.messages.blank'))
      end

      it 'sets errors.messages.too_long' do
        task = Task.create(title: 'A' * 101, details: 'B' * 1001, status: :completed, priority: :high)
        expect(task).to_not be_valid
        expect(task.errors[:title]).to include(I18n.t('activerecord.errors.messages.too_long', count: 100))
        expect(task.errors[:details]).to include(I18n.t('activerecord.errors.messages.too_long', count: 1000))
      end
    end
  end
end
