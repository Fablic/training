require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    context 'When using valid data' do
      it 'is valid when title/details is within their maximum length' do
        user = User.create(username: 'a' * 25, password_digest: '角' * 10, role: :admin)
        expect(user).to be_valid
        expect(user.username).to eq('a' * 25)
        expect(user.password_digest).to eq('角' * 10)
      end

      it 'sets default enums if not provided' do
        user = User.create(username: 'User1', password_digest: 'password1')
        expect(user).to be_valid
        expect(user.role).to eq(:member.to_s)
        expect(user.username).to eq('User1')
        expect(user.password_digest).to eq('password1')
      end
    end

    context 'When using invalid data' do
      it 'sets errors.messages.blank' do
        user = User.create(username: ' ', password_digest: nil)
        expect(user).to_not be_valid
        expect(user.errors[:username]).to include(I18n.t('activerecord.errors.messages.blank'))
        expect(user.errors[:password_digest]).to include(I18n.t('activerecord.errors.messages.blank'))
      end

      it 'sets errors.messages about invalid length' do
        user = User.create(username: 'A' * 26, password_digest: 'B' * 4)
        expect(user).to_not be_valid
        expect(user.errors[:username]).to include(I18n.t('activerecord.errors.messages.too_long', count: 25))
        expect(user.errors[:password_digest]).to include(I18n.t('activerecord.errors.messages.too_short', count: 5))
      end
    end
  end

  describe 'Associations' do
    context 'Linking user to task' do
      before do
        @user = User.create(username: 'User1', password_digest: 'password1')
        @task = Task.create(title: 'Valid Title', details: 'Valid details', user: @user)
      end

      it 'links the user to task model' do
        expect(@task).to be_valid
        expect(@task.user).to eq @user
        expect(@user.tasks[0]).to eq @task
      end

      it 'sets nil to Task.user when user is destroyed' do
        @user.destroy
        @task.reload

        expect(@task).to be_valid
        expect(@task.user).to be_nil
      end
    end
  end
end
