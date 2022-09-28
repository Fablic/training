require 'rails_helper'

RSpec.describe Function, type: :model do
  describe '#is_stopped' do
    before do
      FactoryBot.create(:function, id: Function::FUNC_ID_SYSTEM, status: true)
      FactoryBot.create(:function, id: Function::FUNC_ID_CREATE, status: false)
    end

    context '開始状態の場合' do
      subject(:is_stopped) { Function.is_stopped?(Function::FUNC_ID_SYSTEM) }

      it { is_expected.to be(false) }
    end

    context '停止状態の場合' do
      subject(:is_stopped) { Function.is_stopped?(Function::FUNC_ID_CREATE) }

      it { is_expected.to be(true) }
    end
  end
end
