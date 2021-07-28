# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  it { expect(task).to have_attributes(name: 'do homework', description: 'Deadline is August 31.') }

  describe 'validation' do
    let(:task) { build(:task) }

    it 'is invalid without name' do
      task.name = nil
      task.valid?
      expect(task.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with too long name' do
      task.name = 'a' * 256
      task.valid?
      expect(task.errors[:name]).to include('is too long (maximum is 255 characters)')
    end

    it 'is valid with 255 characters name' do
      task.name = 'a' * 255
      expect(task).to be_valid
    end
  end
end
