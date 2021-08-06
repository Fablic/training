require 'rails_helper'

RSpec.describe Mode, type: :model do
  describe 'maintenance_start' do
    let!(:other_mode) { create(:mode, mode_name: 'other') }
    context 'mode_name「maintenance」が存在する場合' do
      let!(:maintenance_mode) { create(:mode, mode_name: 'maintenance', value: false) }
      it 'メンテナンスモードを開始できること' do
        expect(Mode.maintenance_start).to eq true
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
      let!(:maintenance_mode) { create(:mode, mode_name: 'maintenance', value: false) }
      it 'メンテナンスモードを終了できること' do
        expect(Mode.maintenance_end).to eq true
      end
    end
    context 'mode_name「maintenance」が存在しない場合' do
      it 'メンテナンスモードを終了できないこと' do
        expect(Mode.maintenance_end).to eq false
      end
    end
  end
end
