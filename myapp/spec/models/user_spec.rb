require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = create(:user)
  end

  it 'check user validates' do
    expect(@user).to be_valid

    @user = build(:user, name: '')
    expect(@user.valid?).to eq false

    @user = build(:user, personal_id: '')
    expect(@user.valid?).to eq false

    @user = build(:user, password: '')
    expect(@user.valid?).to eq false
  end

end
