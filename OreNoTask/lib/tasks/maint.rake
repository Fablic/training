# frozen_string_literal: true

namespace :maint do
  desc 'メンテナンスモード切り替え'
  task start: :environment do
    require 'fileutils'
    FileUtils.touch('on_maint')
  end

  task stop: :environment do
    File.delete('on_maint') if File.exist?('on_maint')
  end
end
