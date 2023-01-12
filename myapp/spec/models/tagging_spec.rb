# == Schema Information
#
# Table name: taggings
#
#  id         :integer          unsigned, not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer          not null
#  task_id    :integer          not null
#
require 'rails_helper'

RSpec.describe Tagging, type: :model do
  describe 'associations' do
    it { should belong_to(:tag).class_name('Tag') }
    it { should belong_to(:task).class_name('Task') }
  end
end
