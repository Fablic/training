require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { FactoryBot.create :user }
  let(:task) { Task.new(name: name, description: description, status: status, user_id: user.id) }
  let(:name) { 'タスク名' }
  let(:description) { '詳細な説明' }
  let(:status) { 'todo' }

  context 'すべての項目が入力されている場合' do
    it ('有効であること') { expect(task).to be_valid }
  end

  context 'タスク名がない場合' do
    let(:name) { '' }

    it '無効となること' do
      task.valid?
      expect(task.errors.errors[0].full_message).to include('タスク名を入力してください')
    end
  end

  context 'タスク名が15文字の場合' do
    let(:name) { '１２３４５６７８９０１２３４５' }

    it ('有効であること') { expect(task).to be_valid }
  end

  context 'タスク名が16文字の場合' do
    let(:name) { '１２３４５６７８９０１２３４５６' }

    it '無効となること' do
      task.valid?
      expect(task.errors.errors[0].full_message).to include('タスク名は15文字以内で入力してください')
    end
  end

  context 'タスク詳細が50文字の場合' do
    let(:description) { '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０' }

    it ('有効となること') { expect(task).to be_valid }
  end

  context 'タスク詳細が51文字の場合' do
    let(:description) { '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１' }

    it '無効となること' do
      task.valid?
      expect(task.errors.errors[0].full_message).to include('タスク詳細は50文字以内で入力してください')
    end
  end

  context 'ステータスが定義されていない値の場合' do
    let(:status) { 'not-defined' }

    it '無効となること' do
      expect { task }.to raise_error(ArgumentError, "'not-defined' is not a valid status")
    end
  end
end
