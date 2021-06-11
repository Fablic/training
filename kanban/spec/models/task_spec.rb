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

  it 'タスク名が15文字の場合、有効となること' do
    task = Task.new(
      name: '１２３４５６７８９０１２３４５',
      description: '詳細な説明',
    )
    expect(task).to be_valid
  end

  it 'タスク名が16文字の場合、無効となること' do
    task = Task.new(
      name: '１２３４５６７８９０１２３４５６',
      description: '詳細な説明',
    )
    task.valid?
    expect(task.errors.errors[0].full_message).to include('タスク名は15文字以内で入力してください')
  end

  it 'タスク詳細が50文字の場合、有効となること' do
    task = Task.new(
      name: 'タスク名',
      description: '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０',
    )
    expect(task).to be_valid
  end

  it 'タスク詳細が51文字の場合、無効となること' do
    task = Task.new(
      name: 'タスク名',
      description: '１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１',
    )
    task.valid?
    expect(task.errors.errors[0].full_message).to include('タスク詳細は50文字以内で入力してください')
  end
end
