require 'rails_helper'

RSpec.describe User, type: :model do

  context 'when straight pattern' do
    let(:user) { build(:user) }
    it { expect(user).to be_valid }
  end

  context 'when email is nil' do
    let(:user) { build(:user, email: nil) }
    it { expect(user).to be_invalid }
  end

  context 'when email is invalid format' do
    let(:user) { build(:user, email: 'hoge') }
    it {
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    }
  end

  context 'when email aleady exit' do
    let!(:user1) { create(:user, email: 'hoge@example.com') }
    let(:user2) { build(:user, email: 'hoge@example.com') }
    it {
      expect(user2).to be_invalid
      expect(user2.errors[:email]).to be_present
    }
  end

  context 'when first_name is max length' do
    let(:user) { build(:user, first_name: 'n' * 20) }
    it { expect(user).to be_valid }
  end

  context 'when first_name is over length' do
    let(:user) { build(:user, first_name: 'n' * 21) }
    it {
      expect(user).to be_invalid
      expect(user.errors[:first_name]).to be_present
    }
  end

  context 'when first_name is nil' do
    let(:user) { build(:user, first_name: nil) }
    it {
      expect(user).to be_invalid
      expect(user.errors[:first_name]).to be_present
    }
  end

  context 'when last_name is max length' do
    let(:user) { build(:user, last_name: 'n' * 20) }
    it { expect(user).to be_valid }
  end

  context 'when last_name is over length' do
    let(:user) { build(:user, last_name: 'n' * 21) }
    it {
      expect(user).to be_invalid
      expect(user.errors[:last_name]).to be_present
    }
  end

  context 'when last_name is nil' do
    let(:user) { build(:user, last_name: nil) }
    it {
      expect(user).to be_invalid
      expect(user.errors[:last_name]).to be_present
    }
  end

  describe 'check destory validation' do
    context 'when there are two admin user' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :admin) }

      it 'can delete admin user' do
        user1.destroy!
        expect(User.count).to eq(1)
      end
    end

    context 'when there is only one admin user' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :general) }

      it 'can not delete admin user' do
        expect {
          user1.destroy!
        }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
  end

  describe 'check update validation' do
    context 'when there are two admin user' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :admin) }

      it 'admin user can turn into general user' do
        user1.role = :general
        user1.save
        expect(User.where(role: :admin).count).to eq(1)
      end
    end

    context 'when there is only one admin user' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :general) }

      it 'admin user can not turn into general user' do
        user1.role = :general
        expect{
          user1.save!
        }.to raise_error(ActiveRecord::RecordInvalid)
        expect(User.where(role: :admin).count).to eq(1)
      end
    end
  end
end
