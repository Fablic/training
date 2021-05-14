require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test 'name with nil is not valid' do
    task = tasks(:base)
    task.name = nil
    refute task.valid?
    assert_includes(task.errors.messages, :name)
  end

  test 'description with nil is not valid' do
    task = tasks(:base)
    task.description = nil
    refute task.valid?
    assert_includes(task.errors.messages, :description)
  end

  test 'due_date can be nil as well as Time' do
    task = tasks(:with_due_date)
    task.due_date = nil
    assert task.valid?
  end

  test 'priority can have defined value as enum' do
    task = tasks(:base)
    assert task.high!
    assert task.normal!
    assert task.low!
  end

  test 'status can have defined value as enum' do
    task = tasks(:base)
    assert task.waiting!
    assert task.doing!
    assert task.done!
  end
end
