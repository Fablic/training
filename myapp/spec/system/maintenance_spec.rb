# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'maintenance', type: :system do
  before(:all) do
    Rails.application.load_tasks
  end

  describe '#rake' do
    let(:start) { Rake.application['maintenance:start'] }
    let(:stop) { Rake.application['maintenance:stop'] }

    context 'when the maintenance is started' do
      it 'start maint' do
        start.invoke
        visit login_path
        expect(page).to have_content 'メンテナンス中'
      end
    end

    context 'when the maintenance is stoped' do
      it 'stop maint' do
        start.invoke
        stop.invoke
        visit login_path
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
