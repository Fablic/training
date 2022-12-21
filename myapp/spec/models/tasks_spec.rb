require 'rails_helper'

describe Task, type: :model do
  describe 'validations' do
    subject { build(:task) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
