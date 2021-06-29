# frozen_string_literal: true

RSpec.shared_context 'set_user' do
  let(:user) { create(:user) }
  before do
    login_as(user)
  end

  context 'when current_user is nil' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
    end

    it 'redirect to login page' do
      visit root_path

      expect(current_path).to eq login_path
    end
  end

  def login_as(user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end
end
