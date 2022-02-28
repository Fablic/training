require 'rails_helper'

RSpec.describe Task, type: :model do
  fixtures :boards, :tasks, :statuses, :priorities, :status_steps

  it 'skip status validation when create' do
    subject = Task.new
    subject.board_id = 1
    subject.priority_id = 1
    subject.status_id = 2
    subject.title = 'some_title'
    subject.contents = 'some_contents'
    subject.due_date = DateTime.now
    subject.created_at = DateTime.now + 1.week
    subject.modified_at = DateTime.now + 1.week
    expect(subject).to be_valid
  end

  it 'valid status change' do
    subject = Task.find(4)
    subject.status_id = 1
    expect(subject).to be_valid
  end

  it 'invalid status change' do
    subject = Task.find(4)
    subject.status_id = 2
    expect(subject).to_not be_valid
  end

  it 'valid priority and status' do
    subject = Task.new
    subject.board_id = 1
    subject.priority_id = 1
    subject.status_id = 1
    subject.title = 'some_title'
    subject.contents = 'some_contents'
    subject.due_date = DateTime.now
    subject.created_at = DateTime.now + 1.week
    subject.modified_at = DateTime.now + 1.week
    expect(subject).to be_valid
  end

  it 'invalid priority' do
    subject = Task.new
    subject.board_id = 1
    subject.priority_id = 999
    subject.status_id = 1
    subject.title = 'some_title'
    subject.contents = 'some_contents'
    subject.due_date = DateTime.now
    subject.created_at = DateTime.now + 1.week
    subject.modified_at = DateTime.now + 1.week
    expect(subject).to_not be_valid
  end

  it 'invalid status' do
    subject = Task.new
    subject.board_id = 1
    subject.priority_id = 1
    subject.status_id = 999
    subject.title = 'some_title'
    subject.contents = 'some_contents'
    subject.due_date = DateTime.now
    subject.created_at = DateTime.now + 1.week
    subject.modified_at = DateTime.now + 1.week
    expect(subject).to_not be_valid
  end

  it 'invalid title' do
    subject = Task.new
    subject.board_id = 1
    subject.priority_id = 1
    subject.status_id = 999
    subject.title = ''
    subject.contents = 'some_contents'
    subject.due_date = DateTime.now
    subject.created_at = DateTime.now + 1.week
    subject.modified_at = DateTime.now + 1.week
    expect(subject).to_not be_valid
  end
end
