# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maintenance, type: :model do
  it 'Create new' do
    maintenance = FactoryBot.build(:maintenance)

    expect(maintenance).to be_valid
  end

  it 'empty reason (Error)' do
    maintenance = FactoryBot.build(:maintenance, reason: '')

    expect(maintenance).not_to be_valid
  end

  it 'nil reason (Error)' do
    maintenance = FactoryBot.build(:maintenance, reason: nil)

    expect(maintenance).not_to be_valid
  end

  it 'nil start_datetime (Error)' do
    maintenance = FactoryBot.build(:maintenance, start_datetime: nil)

    expect(maintenance).not_to be_valid
  end

  it 'nil end_datetime (Error)' do
    maintenance = FactoryBot.build(:maintenance, end_datetime: nil)

    expect(maintenance).not_to be_valid
  end
end
