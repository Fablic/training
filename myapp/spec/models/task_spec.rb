# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task Model', type: :model do
  let!(:task) { FactoryBot.create(:task) }
  let!(:tasks) { FactoryBot.create_list(:task, 10) }

  describe 'title' do
    context 'when blank' do
      it 'is not valid' do
        task.title = ''
        expect(task.valid?).to eq false
      end
    end

    context 'when length is equal 255.' do
      it 'is valid' do
        task.title = Faker::Base.regexify('[a-zA-Z0-9亜-熙ぁ-んァ-ヶ]{255}')
        expect(task.valid?).to eq true
      end
    end

    context 'when length is more than 255' do
      it 'is not valid' do
        task.title = Faker::Base.regexify('[a-zA-Z0-9亜-熙ぁ-んァ-ヶ]{256}')
        expect(task.valid?).to eq false
      end
    end
  end

  describe 'description' do
    it 'can be blank' do
      task.description = ''
      expect(task.valid?).to eq true
    end

    it 'is equal or less than 768' do
      task.description = Faker::Base.regexify('[a-zA-Z0-9亜-熙ぁ-んァ-ヶ]{769}')
      expect(task.valid?).to eq false
    end
  end

  describe 'priority' do
    it 'can be blank' do
      task.priority = ''
      expect(task.valid?).to eq true
    end

    it 'is one of enum keys' do
      expect {
        # enum key以外を設定
        task.priority = Faker::Lorem.characters(number: 50)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'status' do
    it 'can be blank' do
      task.status = ''
      expect(task.valid?).to eq true
    end

    it 'is one of enum keys' do
      expect {
        # enum key以外を設定
        task.status = Faker::Lorem.characters(number: 50)
      }.to raise_error(ArgumentError)
    end
  end

  describe 'expires_at' do
    it 'can be blank' do
      task.expires_at = ''
      expect(task.valid?).to eq true
    end
  end

  describe '#search_title' do
    context 'when prefix match' do
      it 'can find the row' do
        result = Task.search_title(tasks.first.title.slice(0, 5))
        expect(result.first.title == tasks.first.title).to eq true
      end
    end

    context 'when backward match' do
      it 'can find the row' do
        result = Task.search_title(tasks.first.title.slice(-5, 5))
        expect(result.first.title == tasks.first.title).to eq true
      end
    end
  end

  describe '#search_status' do
    context 'when prefix match' do
      it 'can find the row' do
        result = Task.search_status(tasks.last.status)
        expect(result.last.title == tasks.last.title).to eq true
      end
    end
  end

  describe '#search' do
    let!(:tasks) { FactoryBot.create_list(:task, 10, :with_labels) }

    context 'with multi params' do
      let(:param) {
        {
          title: tasks.first.title.slice(5, 5),
          status: tasks.first.status,
          label_id: tasks.first.labels.first.id,
        }
      }

      it 'can find the row' do
        result = Task.search(param)
        expect(result.first.title).to eq tasks.first.title
      end
    end

    context 'with title param' do
      it 'can find the row' do
        result = Task.search({ title: tasks.first.title.slice(5, 5) })
        expect(result.first.title).to eq tasks.first.title
      end
    end

    context 'with status params' do
      it 'can find the row' do
        result = Task.search({ status: tasks.first.status })
        expect(result.pluck(:status).uniq).to eq [tasks.first.status]
      end
    end

    context 'with label_id params' do
      it 'can find the row' do
        result = Task.search({ label_id: tasks.first.labels.first.id })
        expect(result.first.title).to eq tasks.first.title
      end
    end
  end
end
