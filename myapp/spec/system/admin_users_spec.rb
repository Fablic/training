# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUsers', type: :system do
  let(:user) { create(:user, name: 'test', admin: true) }

  describe '#index' do
    before do
      login(user: user)
    end
  end
end
