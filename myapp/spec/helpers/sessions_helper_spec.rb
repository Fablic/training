require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  context 'check to log_in' do
    it { expect(helper.log_in(user)).to eq 1 }
  end

  context 'check to current_user' do
    before do
      helper.log_in(user)
    end
    it { expect(helper.current_user).to eq user }
  end

  context 'check to logged_in?' do
    it 'current_user false' do
      expect(helper.logged_in?).to eq false
    end

    it 'current_user true' do
      helper.log_in(user)
      helper.logged_in?
      expect(helper.logged_in?).to eq true
    end
  end

  context 'check to require_login' do
    it 'redirect_to login' do
      helper.logged_in?
      pending('ヘルパー側でredirect_toのメソッドを読み込まない為、保留')
      expect(helper.require_login).to eq false
    end
  end

  context 'check to log_out' do
    it 'logout' do
      expect(helper.log_in(user)).to eq 1
      expect(helper.current_user).to eq user
      expect(session[:user_id]).to eq 1

      helper.log_out
      expect(session[:user_id]).to eq nil
      expect(helper.current_user).to eq nil
    end
  end
end
