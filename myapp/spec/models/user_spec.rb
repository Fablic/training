# == Schema Information
#
# Table name: users
#
#  id              :integer          unsigned, not null, primary key
#  email           :string(255)      not null
#  is_admin        :boolean          default(FALSE), not null
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  tasks_count     :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }

    it 'duplicated email is not allowed' do
      user = create(:user)
      duplicated_email_user = build(:user, email: user.email)
      expect(duplicated_email_user).to be_invalid
    end

    it 'unpermitted format of email is not allowed' do
        invalid_email = 'haha'
        user = build(:user, email: invalid_email)
        expect(user).to be_invalid
      end
  end

  describe 'has_many' do
    it { should have_many(:tasks) }
  end
end
