# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:label) }
  end
end
