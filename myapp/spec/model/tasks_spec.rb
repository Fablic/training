require 'rails_helper'

RSpec.describe 'Tasks Model', type: :model do
  describe 'バリデーションのテスト' do
    let(:task) { create(:task) }
    subject { task.valid? }

    context 'nameカラム' do
      it '空欄でないこと' do
        task.name = ''
        is_expected.to eq false
      end

      it '255文字以下であること' do
        task.name = Faker::Lorem.characters(number:256)
        expect(task.valid?).to eq false
      end
    end

    context 'descriptionカラム' do
      it '空欄でないこと' do
        task.description = ''
        is_expected.to eq false
      end

      it '1024文字以下であること' do
        task.description = Faker::Lorem.characters(number:1025)
        expect(task.valid?).to eq false
      end
    end
  end
end
