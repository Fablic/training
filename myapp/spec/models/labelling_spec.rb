require 'rails_helper'

RSpec.describe Labelling, type: :model do
  let(:labelling) { create(:labelling) }

  describe 'バリデーションテスト' do
    context 'task_idとlabel_idがあるとき' do
      it '正常に登録できる' do
        expect(labelling).to be_valid
      end
    end

    context 'task_idがないとき' do
      it '無効であること' do
        labelling.task_id = nil
        expect(labelling).to be_invalid
      end
    end

    context 'label_idがないとき' do
      it '無効であること' do
        labelling.label_id = nil
        expect(labelling).to be_invalid
      end
    end
  end
end
