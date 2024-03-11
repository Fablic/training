require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validaton' do
    it 'create label successfully' do
      label = build(:label)
      expect(label).to be_valid
    end

    it 'no error messages when label created successfully' do
      label = build(:label)
      label.valid?
      expect(label.errors).to be_empty
    end

    it 'label cannot be created without name' do
      label = build(:label, name: '')
      expect(label).to be_invalid
    end

    it 'show error messages if name is empty' do
      label = build(:label, name: '')
      label.valid?
      expect(label.errors[:name]).to eq ["can't be blank"]
    end

    it 'label cannot be created with name longer than 255 characters' do
      label = build(:label, name: 'a' * 256)
      expect(label).to be_invalid
    end

    it 'show error messages if name is longer than 255 characters' do
      label = build(:label, name: 'a' * 256)
      label.valid?
      expect(label.errors[:name]).to eq ['is too long (maximum is 255 characters)']
    end
  end

  describe 'check_scope' do
    let!(:user_one) { create(:user, username: 'Label1', id: 1) }
    let!(:user_two) { create(:user, username: 'Label2', id: 2) }
    let!(:label_first) { create(:label, name: 'Label1', user: user_one) }
    let!(:label_second) { create(:label, name: 'Label2', user: user_two) }
    let!(:label_third) { create(:label, name: 'Label3', user: user_one) }

    it 'get own label successfully', :aggregate_failures do
      labels = Label.get_own_labels(user_two)
      expect(labels).to include label_second
      expect(labels).not_to include label_first
      expect(labels).not_to include label_third
    end
  end
end
