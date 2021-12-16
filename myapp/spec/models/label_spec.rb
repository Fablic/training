# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'label' do
    let!(:label) { FactoryBot.create(:label) }

    context 'when blank' do
      it 'is not valid' do
        label.name = ''
        expect(label.valid?).to eq false
      end
    end

    context 'when strings more than 16' do
      it 'is not valid' do
        label.name = Faker::Lorem.characters(number: 17)
        expect(label.valid?).to eq false
      end
    end
  end
end
