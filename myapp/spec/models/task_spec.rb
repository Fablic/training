require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  TITLE_MAX_LENGTH = 50

  let(:title) {'test title'}
  let(:description) {'test description'}
  let!(:task) {Task.new(title: title, description: description)}

  describe 'title' do
    context "#{ TITLE_MAX_LENGTH }文字以内" do
      let(:title) {'t' * TITLE_MAX_LENGTH}
      it 'バリデーションを通ること' do
        expect(task).to be_valid
      end
    end

    context "#{ TITLE_MAX_LENGTH }文字より多い" do
      let(:title) {'t' * (TITLE_MAX_LENGTH + 1)}
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end

    context '入力が空の場合' do
      let(:title) {''}
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end
    
  end

  describe "description" do
    context '入力が空の場合' do
      let(:description) {''}
      it 'バリデーションが設定されていないこと' do
        expect(task).to be_valid
      end
    end
  end
  
end
