require 'rails_helper'

describe SystemMaintenance, type: :model do
  describe '#is_started' do
    before do
      FactoryBot.create(:system_maintenance, key: '1', status: SystemMaintenance.statuses[:started])
      FactoryBot.create(:system_maintenance, key: '2', status: SystemMaintenance.statuses[:stopped])
    end

    context '開始状態の場合' do
      subject(:is_started) { SystemMaintenance.is_started('1') }

      it { is_expected.to be(true) }
    end

    context '停止状態の場合' do
      subject(:is_started) { SystemMaintenance.is_started('2') }

      it { is_expected.to be(false) }
    end
  end
  describe '#is_stopped' do
    before do
      FactoryBot.create(:system_maintenance, key: '1', status: SystemMaintenance.statuses[:started])
      FactoryBot.create(:system_maintenance, key: '2', status: SystemMaintenance.statuses[:stopped])
    end

    context '開始状態の場合' do
      subject(:is_stopped) { SystemMaintenance.is_stopped('1') }

      it { is_expected.to be(false) }
    end

    context '停止状態の場合' do
      subject(:is_stopped) { SystemMaintenance.is_stopped('2') }

      it { is_expected.to be(true) }
    end
  end
end
