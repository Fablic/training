# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe 'validation' do
    context '正常値のとき' do
      it { expect(FactoryBot.build(:label)).to be_valid }
    end

    describe 'ラベル名' do
      let!(:label) { FactoryBot.build(:label, name: name) }
      subject { label }

      context '空のとき' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context '1文字のとき' do
        let(:name) { 'a' }
        it { is_expected.to be_valid }
      end

      context '20文字のとき' do
        let(:name) { 'a' * 20 }
        it { is_expected.to be_valid }
      end

      context '21文字のとき' do
        let(:name) { 'a' * 21 }
        it { is_expected.to be_invalid }
      end
    end
  end
end
