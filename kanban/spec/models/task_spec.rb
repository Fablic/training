require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'nameとdescriptionが有効であること' do
    task = Task.new(
      name: 'タスク名',
      description: '詳細な説明',
    )
    expect(task).to be_valid
  end

  it 'タスク名がない場合、無効となること' do
    task = Task.new(
      name: '',
      description: '詳細な説明',
    )
    task.valid?
    expect(task.errors.errors[0].full_message).to include('タスク名を入力してください')
  end

  it 'タスク名が30文字場合、有効となること' do
    task = Task.new(
      name: '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０',
      description: '詳細な説明',
    )
    expect(task).to be_valid
  end

  it 'タスク名が31文字場合、無効となること' do
    task = Task.new(
      name: '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１',
      description: '詳細な説明',
    )
    task.valid?
    expect(task.errors.errors[0].full_message).to include('タスク名は30文字以内で入力してください')
  end

  it 'タスク詳細が100文字場合、有効となること' do
    task = Task.new(
      name: 'タスク名',
      description: '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０',
    )
    expect(task).to be_valid
  end

  it 'タスク詳細が101文字場合、無効となること' do
    task = Task.new(
      name: 'タスク名',
      description: '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１',
    )
    task.valid?
    expect(task.errors.errors[0].full_message).to include('タスク詳細は100文字以内で入力してください')
  end
end
