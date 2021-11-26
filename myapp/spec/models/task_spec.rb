# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task Model', type: :model do
  describe 'validation' do
    subject { proc { task.valid? } }

    let!(:task) { FactoryBot.create(:task) }

    describe 'title' do
      it 'is not valid if it is blank.' do
        task.title = ''
        expect(task.valid?).to eq false
      end

      it 'is valid if its length is equal 255.' do
        task.title = Faker::Base.regexify('[a-zA-Z0-9亜-熙ぁ-んァ-ヶ]{255}')
        expect(task.valid?).to eq true
      end

      it 'is not valid if its length is more than 255.' do
        task.title = Faker::Base.regexify('[a-zA-Z0-9亜-熙ぁ-んァ-ヶ]{256}')
        expect(task.valid?).to eq false
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
end
