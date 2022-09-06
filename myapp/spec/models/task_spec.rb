# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end

  describe 'enums' do
    it {
      is_expected.to define_enum_for(:priority).with_values(
        low: 0,    # 低
        normal: 1, # 普通
        high: 2    # 高
      ).with_prefix
    }

    it {
      is_expected.to define_enum_for(:status).with_values(
        untouched: 0, # 未着手
        touched: 1,   # 着手中
        completed: 2  # 完了
      ).with_prefix
    }
  end
end
