require 'rails_helper'

RSpec.describe Task, type: :model do

  context 'When there is no validation error' do
    let(:label) { create(:label) }
    it 'can create a label' do
      expect(label).to be_valid
    end
  end

  context 'When the title is be more than max length' do
    let(:label) { Label.new(name: 'T' * 17) }
    it 'label cannot be more than max length' do
      expect(label).not_to be_valid
      expect(label.errors[:name]).to be_present
    end
  end
end
