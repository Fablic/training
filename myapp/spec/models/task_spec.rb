# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task Model', type: :model do
  let!(:task) { FactoryBot.create(:task) }

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
end
