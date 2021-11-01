require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:params) { { name: 'test_name', email: 'one@example.com', role: :member, password: 'password' } }

  shared_examples 'When it was invalid.' do
    it 'Invalidated and returns an error message' do
      params[column.to_sym] = val
      begin
        user = User.create(params)
        expect(user).not_to be_valid
        expect(user.errors.messages).to include(column.to_sym)
        errors.map { |error| expect(user.errors).to be_of_kind(column.to_sym, error.to_sym) }
      rescue StandardError => e
        puts e
      end
    end
  end

  shared_examples 'When it was valid.' do
    it 'Invalidated and returns an error message' do
      params[column.to_sym] = val
      user = User.create(params)
      expect(user).to be_valid
      expect(user.errors.messages).not_to include(column.to_sym)
    end
  end

  describe '#name' do
    let(:column) { 'name' }

    context 'When the correct value is entered.' do
      let(:val) { 'ABCDEF' }
      it_behaves_like 'When it was valid.'
    end

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank too_short] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When empty is set.' do
      let(:val) { '' }
      let(:errors) { %w[blank too_short] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the number of characters in the title is exceeded.' do
      let(:val) { 'a' * 21 }
      let(:errors) { ['too_long'] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the title is low on characters.' do
      let(:val) { 'a' * 2 }
      let(:errors) { ['too_short'] }
      it_behaves_like 'When it was invalid.'
    end
  end

  describe '#email' do
    let(:column) { 'email' }

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank invalid] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When empty is set.' do
      let(:val) { '' }
      let(:errors) { %w[blank invalid] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the format of the email is out of regulation' do
      it 'When it was valid.' do
        valid_addresses = %w[
          user@example.com
          USER@foo.COM
          A_US-ER@foo.bar.org
          first.last@foo.jp
          alice+bob@baz.cn
        ]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    context 'When the same email address is registered.' do
      it 'When it was invalid.' do
        expect(user.dup).not_to be_valid
      end
    end
  end

  describe '#role' do
    let(:column) { 'role' }

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When empty is set.' do
      let(:val) { '' }
      let(:errors) { %w[blank] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When unintended value  is set' do
      let(:val) { :test }
      let(:errors) { %w[inclusion] }
      it_behaves_like 'When it was invalid.'
    end
  end

  describe '#password' do
    let(:column) { 'password' }

    context 'When nil is set.' do
      let(:val) { nil }
      let(:errors) { %w[blank] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When empty is set.' do
      let(:val) { ' ' }
      let(:errors) { %w[blank too_short] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the number of characters in the title is exceeded.' do
      let(:val) { 'a' * 21 }
      let(:errors) { ['too_long'] }
      it_behaves_like 'When it was invalid.'
    end

    context 'When the title is low on characters.' do
      let(:val) { 'a' * 2 }
      let(:errors) { ['too_short'] }
      it_behaves_like 'When it was invalid.'
    end
  end

  describe '#tasks dependent' do
    context 'When a user is deleted.' do
      it 'Task will also be deleted.' do
        user_id = user.id
        create_list(:task, 10, user: user)
        user.destroy
        expect(Task.where(user_id: user_id).count).to eq 0
      end
    end
  end
end
