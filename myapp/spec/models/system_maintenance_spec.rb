require 'rails_helper'

describe SystemMaintenance, type: :model do
  describe '#is_maintenance' do
    before do
      FactoryBot.create(:system_maintenance, key: '1', maintenance_flg: true)
      FactoryBot.create(:system_maintenance, key: '2', maintenance_flg: false)
    end

    context 'メンテナンス状態の場合' do
      subject(:is_maintenance) { SystemMaintenance.is_maintenance?('1') }

      it { is_expected.to be(true) }
    end

    context 'メンテナンス状態でない場合' do
      subject(:is_maintenance) { SystemMaintenance.is_maintenance?('2') }

      it { is_expected.to be(false) }
    end
  end
end
