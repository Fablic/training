require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validation' do
    describe 'name' do
      context '0文字' do
        subject(:label) { FactoryBot.build(:label, name: '') }

        it { is_expected.to be_invalid }
      end

      context '1文字' do
        subject(:label) { FactoryBot.build(:label, name: '1') }

        it { is_expected.to be_valid }
      end

      context '64文字' do
        subject(:label) { FactoryBot.build(:label, name: '1' * 64) }

        it { is_expected.to be_valid }
      end

      context '65文字' do
        subject(:label) { FactoryBot.build(:label, name: '1' * 65) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
