# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validation' do
    let(:name) { 'design' }
    subject { build(:label, name: name) }

    context '登録可能な形式' do
      it { is_expected.to be_valid }
    end

    describe 'name' do
      context 'nameが空の場合' do
        let(:name) { nil }
        it { is_expected.to_not be_valid }
      end

      context '重複した名前の場合' do
        before { create(:label, name: name) }
        it { is_expected.to_not be_valid }
      end
    end
  end
end
