require 'rails_helper'

RSpec.describe Maintenance, type: :model do
  describe 'validation' do
    context 'is_maintenance column' do
      it 'success' do
        t = Maintenance.new(
          is_maintenance: 1,
          started_at: '2024-09-01T15:00',
          ended_at: '2024-09-01T15:15',
        )
        expect(t).to be_valid
      end

      it 'failed when it is invalid value' do
        expect do
          Maintenance.new(
            is_maintenance: 999,
            started_at: '2024-09-01T15:00',
            ended_at: '2024-09-01T15:15',
          )
        end.to raise_error(ArgumentError)
      end
    end

    context 'started_at, ened_at column' do
      it 'failed when started_at is greater than ended_at' do
        t = Maintenance.new(
          is_maintenance: 1,
          started_at: '2024-09-01T15:15',
          ended_at: '2024-09-01T15:00',
        )
        t.valid?
        expect(t.errors[:ended_at]).to include('は2024-09-01 15:15:00 +0900より大きい値にしてください')
      end
    end
  end
end
