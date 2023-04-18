# == Schema Information
#
# Table name: labels
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_labels_on_name  (name)
#
require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:task_labels).dependent(:destroy) }
    it { is_expected.to have_many(:tasks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
  end
end
