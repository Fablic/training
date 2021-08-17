require 'rails_helper'

RSpec.describe Mode, type: :model do
  describe 'maintenance_start' do
    let!(:other_mode) { create(:mode, mode_name: 'other') }
    context 'mode_name「maintenance」が存在する場合' do
      let!(:maintenance_mode) { create(:mode, mode_name: 'maintenance', value: false) }
      it 'mode_name「maintenance」のvalueが「true」になり、メンテナンスモードを開始できること' do
        maintenance_mode_start = Mode.maintenance_start
        maintenance = Mode.find_by(mode_name: 'maintenance')
        expect(maintenance_mode_start).to eq true
        expect(maintenance.value).to eq true
      end
    end
    context 'mode_name「maintenance」が存在しない場合' do
      it 'メンテナンスモードを開始できないこと' do
        expect(Mode.maintenance_start).to eq false
      end
    end
  end

  describe 'maintenance_end' do
    let!(:other_mode) { create(:mode, mode_name: 'other') }
    context 'mode_name「maintenance」が存在する場合' do
      let!(:maintenance_mode) { create(:mode, mode_name: 'maintenance', value: true) }
      it 'mode_name「maintenance」のvalueが「false」になり、メンテナンスモードを終了できること' do
        maintenance_mode_end = Mode.maintenance_end
        maintenance = Mode.find_by(mode_name: 'maintenance')
        expect(maintenance_mode_end).to eq true
        expect(maintenance.value).to eq false
      end
    end
    context 'mode_name「maintenance」が存在しない場合' do
      it 'メンテナンスモードを終了できないこと' do
        expect(Mode.maintenance_end).to eq false
      end
    end
  end
end
