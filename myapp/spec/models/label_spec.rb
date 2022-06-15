require 'rails_helper'

RSpec.describe Label, type: :model do
  name_max_length = 25
  let!(:user) { create(:normal_user) }
  let!(:name) { 'test label' }
  let!(:label) { Label.new(name: name, user_id: user.id)}

  describe 'name' do
    context "#{name_max_length}文字以内" do
      let(:name) { 't' * name_max_length }      
      it 'バリデーションにかからないこと' do
        expect(label).to be_valid  
      end
    end

    context "#{name_max_length}文字より多い" do
      let(:name) { 't' * (name_max_length + 1 ) }      
      it 'バリデーションで弾かれること' do
        expect(label).not_to be_valid  
      end
    end
    
    context '入力が空の場合' do
      let(:name) { '' }
      it 'バリデーションで弾かれること' do
        expect(label).not_to be_valid
      end
    end

    context '既に同じラベル名が登録されていた場合' do
      before { Label.create(name: name, user_id: user.id) }
      it 'バリデーションで弾かれること' do
        expect(label).not_to be_valid
      end
    end
  end
end
