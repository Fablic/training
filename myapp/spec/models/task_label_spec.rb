# == Schema Information
#
# Table name: task_labels
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  label_id   :bigint           not null
#  task_id    :bigint           not null
#
# Indexes
#
#  index_task_labels_on_label_id  (label_id)
#  index_task_labels_on_task_id   (task_id)
#
require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:label) }
  end
end
