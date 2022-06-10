require 'rails_helper'

RSpec.describe Task, type: :model do
  # titleがあれば有効な状態
  it "is valid with a title" do
    task_valid = FactoryBot.build(:task)
    expect(task_valid).to be_valid
  end

  # titleがなければ無効な状態
  it "is invalid wihout a title" do
    task_no_title = FactoryBot.build(:task, :no_title)
    task_no_title.valid?
    expect(task_no_title.errors[:title]).to include("can't be blank")
  end
end
