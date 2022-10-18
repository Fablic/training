# frozen_string_literal: true

require 'rake_helper'

RSpec.describe 'maintenance:execute', type: :task do
  context 'maintenance:execute' do
    let(:temp) { Rails.root.join '/myapp/tmp/maintenance.txt' }

    subject(:task) { Rake.application['maintenance:execute'] }

    it 'correctly exists stdout, maintenance.txt' do
      task.invoke

      expect { puts 'メンテナンスモード開始ッ！' }.to output("メンテナンスモード開始ッ！\n").to_stdout
      expect(File.exist?(temp)).to be_truthy
    end

    it 'correctly exist stdout, does NOT exist maintenance.txt' do
      task.invoke

      expect { puts 'メンテナンスモード終了ッ！' }.to output("メンテナンスモード終了ッ！\n").to_stdout
      expect(File.exist?(temp)).to be_falsy
    end
  end
end
