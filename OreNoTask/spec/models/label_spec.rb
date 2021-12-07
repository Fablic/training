# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:label_name) { 'ラベル名' }

  describe 'バリデーションのテスト' do
    subject { described_class.new(name: label_name) }

    context '全項目入力' do
      it { is_expected.to be_valid }
    end

    context 'label_nameカラムが空欄' do
      let(:label_name) { '' }

      it { is_expected.not_to be_valid }
    end

    context 'label_nameカラムが20文字以内' do
      let(:label_name) { 'a' * 20 }

      it { is_expected.to be_valid }
    end

    context 'label_nameカラムが21文字' do
      let(:label_name) { 'a' * 21 }

      it { is_expected.not_to be_valid }
    end
  end
end
