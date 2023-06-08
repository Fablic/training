require 'rails_helper'

RSpec.describe Maintenance, type: :lib do
  describe 'メンテナンスバッチ' do
    context 'メンテナンス開始' do
      let!(:mainte) { create(:maintenance, status: 0) }

      before do
        Tasks::Batch::Maintenance.start
      end

      it 'メンテナンスモードがオンになる' do
        expect(mainte.reload.status).to eq 1
      end
    end

    context 'メンテナンス終了' do
      let!(:mainte) { create(:maintenance, status: 1) }

      before do
        Tasks::Batch::Maintenance.end
      end

      it 'メンテナンスモードがオフになる' do
        expect(mainte.reload.status).to eq 0
      end
    end
  end
end
