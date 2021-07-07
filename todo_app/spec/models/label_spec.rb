# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validation' do
    subject { build(:label, name: name, color: color) }

    describe 'valid' do
      context 'valid all property' do
        let(:name) { 'ラベル名' }
        let(:color) { nil }

        it { is_expected.to be_valid }
      end

      context 'valid color' do
        let(:name) { 'ラベル名' }
        let(:color) { Label.colors[:warning] }

        it { is_expected.to be_valid }
      end
    end

    describe 'invalid' do
      context 'invalid name nil' do
        let(:name) { nil }
        let(:color) { nil }

        it { is_expected.to_not be_valid }
      end

      context 'invalid name length over' do
        let(:name) { Faker::Alphanumeric.alpha(number: 51) }
        let(:color) { nil }

        it { is_expected.to_not be_valid }
      end

      context 'invalid name is duplicate' do
        let!(:exist_label) { create(:label, name: 'ラベル名の重複テスト') }
        let!(:duplicate_label) { build(:label, name: 'ラベル名の重複テスト') }

        it 'cannot save record' do
          expect(duplicate_label.save).to eq(false)
        end
      end
    end
  end
end
