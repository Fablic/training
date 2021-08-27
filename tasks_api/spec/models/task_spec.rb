# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    before { @user = FactoryBot.create(:user) }
    it 'should valid with some values' do
      task = Task.new(name: 'name', description: 'description', user: @user)
      expect(task).to be_valid
    end

    it 'should reject blank names' do
      task = Task.new(name: '', user: @user)
      expect(task.valid?).to be false
      expect(task.errors[:name].first).to include("Name can't be blank")
    end

    it 'should reject longer names than 255' do
      task = Task.new(name: 'a' * 255, user: @user)
      expect(task.valid?).to be true
      task.name = 'a' * 256
      expect(task.valid?).to be false
      expect(task.errors[:name].first).to include(I18n.t('errors.attributes.name.too_long'))
    end

    it 'should allow several values only for status' do
      valid = %w[open in_progress close]
      task = Task.new(name: 'tmp', user: @user)

      valid.each do |v|
        task.status = v
        expect(task.valid?).to be true
      end

      expect { task.status = :hoge }.to raise_error(ArgumentError)
    end
  end
end
