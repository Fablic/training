# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { Task.new(name: name, desc: desc) }
  let(:name) { 'Task Name' }
  let(:desc) { 'Task description' }

  context 'All items are entered' do
    it ('Should be valid') { expect(task).to be_valid }
  end
end
