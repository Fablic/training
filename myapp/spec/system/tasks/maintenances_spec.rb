require 'rails_helper'
require 'rake_helper'

RSpec.describe 'Maintenances', type: :system do
  subject(:maintenance_start) do
    Rake.application['maintenance:start']
  end
  subject(:maintenance_end) do
    Rake.application['maintenance:end']
  end
  subject(:maintenance_status) do
    Rake.application['maintenance:status']
  end

  after do
    maintenance_end.invoke
  end

  context 'メンテナンスモードのとき' do
    before do
      maintenance_start.invoke
    end

    example 'メンテナンスページが表示' do
      visit root_path
      expect(page).to have_http_status 503
    end

    example 'メンテナンスを終了できるか' do
      maintenance_end.invoke
      visit root_path
      expect(page).to have_http_status 200
    end

    example 'モードの確認ができるか' do
      expect { maintenance_status.invoke }.to output("メンテナンスモードです\n").to_stdout
    end
  end

  context '通常モードのとき' do
    example 'メンテナンスモードに移行できるか' do
      maintenance_start.invoke
      visit root_path
      expect(page).to have_http_status 503
    end

    example 'モードの確認ができるか' do
      expect { maintenance_status.invoke }.to output("通常モードです\n").to_stdout
    end

    example '通常モードでメンテナンスを終了しても何も起こらない' do
      expect { maintenance_end.invoke }.to output("メンテナンスモードは終了しています。通常モードです\n").to_stdout
    end
  end
end
