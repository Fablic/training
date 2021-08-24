# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  context 'cleanup' do
    before do
      @label = FactoryBot.create(:label)
    end

    it 'should remain existing when the label has any tasks' do
      task = FactoryBot.create(:task)
      task.labels << @label

      @label.cleanup

      expect(@label.destroyed?).to be false
    end

    it 'should destroy itself when therere no tasks' do
      @label.cleanup

      expect(@label.destroyed?).to be true
    end
  end
end
