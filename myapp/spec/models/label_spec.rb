# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
  end
end
