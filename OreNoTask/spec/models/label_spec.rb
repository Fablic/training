# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:label_name) { 'ラベル名' }

  describe '正常系' do
    subject { described_class.new(name: label_name) }

    context '全項目入力' do
      it { is_expected.to be_valid }
    end
  end

  describe 'バリデーションのテスト' do
    subject { described_class.new(name: label_name) }

    describe 'label_nameカラム' do
      context '空欄' do
        let(:label_name) { '' }

        it { is_expected.not_to be_valid }
      end

      context '20文字以内' do
        let(:label_name) { 'a' * 20 }

        it { is_expected.to be_valid }
      end

      context '21文字' do
        let(:label_name) { 'a' * 21 }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
