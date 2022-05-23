require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  title_max_length = 50

  let(:title) { 'test title' }
  let(:description) { 'test description' }
  let(:due_date) { '2022/05/10' }
  let(:status) { 0 }
  let!(:task) { Task.new(title: title, description: description, due_date: due_date, status: status) }

  describe 'title' do
    context "#{title_max_length}文字以内" do
      let(:title) { 't' * title_max_length }
      it 'バリデーションを通ること' do
        expect(task).to be_valid
      end
    end

    context "#{title_max_length}文字より多い" do
      let(:title) { 't' * (title_max_length + 1) }
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end

    context '入力が空の場合' do
      let(:title) { '' }
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end
  end

  describe 'description' do
    context '入力が空の場合' do
      let(:description) { '' }
      it 'バリデーションが設定されていないこと' do
        expect(task).to be_valid
      end
    end
  end

  describe 'due_date' do
    context '入力が空の場合' do
      let(:due_date) { '' }
      it 'バリデーションで弾かれること' do
        expect(task).not_to be_valid
      end
    end
  end

  describe 'status' do
    context '入力が空の場合' do
      let(:status) { '' }
      it '正常に登録ができること' do
        expect(task).to be_valid
      end
    end

    context '0, 1, 2の入力の場合' do
      it '入力を受け付けること' do
        [0, 1, 2].each do |v|
          expect(task).to allow_value(v).for(:status)
        end
      end
    end
  end
end
