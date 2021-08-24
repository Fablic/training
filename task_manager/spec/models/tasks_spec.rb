# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task, type: :model do
    before do
        travel_to Date.new(2015,1,1)
    end

    context "登録可能な形式" do
        it "すべて入力した際に登録できる" do
            task = FactoryBot.build(:task)
            expect(task).to be_valid
        end
    end

    context "登録不可能な形式" do
        it "nameが空の場合に登録できない" do
            task = FactoryBot.build(:task, name: nil)
            expect(task).not_to be_valid
        end

        it "in_time_zoneで変換できない形式の場合登録できない" do
            task = FactoryBot.build(:task, due_at:'2021-08aa 10:59:26')
            expect(task).not_to be_valid
        end

        it "現在時刻より以前の場合登録できない" do
            task = FactoryBot.build(:task, due_at:'2013-08-13 10:59:26')
            expect(task).not_to be_valid
        end
    end
end