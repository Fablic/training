require 'rails_helper'

RSpec.describe Task, type: :model do
  # titleがあれば有効な状態
  it "is valid with a title" do
    task_valid = Task.new(
      title: "Rails研修",
      description: "テストをRSpecで書きます",
      expire_at: "2022-06-10 12:00:00",
    )
    expect(task_valid).to be_valid
  end

  # titleがなければ無効な状態
  it "is invalid wihout a title" do
    task_no_title = Task.new(
      title: nil,
    )
    task_no_title.valid?
    expect(task_no_title.errors[:title]).to include("can't be blank")
  end
end
