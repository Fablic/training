# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  it { expect(task).to have_attributes(name: 'do homework', description: 'Deadline is August 31.') }
end
