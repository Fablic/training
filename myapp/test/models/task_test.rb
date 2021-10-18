# frozen_string_literal: true

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test 'check user of task' do
    t = Task.first()
    assert_equal 1, t.user.id
  end

  # test "the truth" do
  #   assert true
  # end
end
