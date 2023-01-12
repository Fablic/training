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
  pending "add some examples to (or delete) #{__FILE__}"
end
