# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maintainance, type: :model do
  describe 'function' do
    describe 'on' do
      let(:reason) { nil }
      before { Maintainance.on(reason) }
      after { File.delete( './config/maintanance.txt' ) }

      context '引数にnilをいれるとき' do
        it {
          file = File.open("./config/maintanance.txt", "r")
          expect( file.read ).to match '\n'
         }
      end

      context '引数に文字列ををいれるとき' do
        let(:reason) { 'メンテナンスのため' }
        it { 
          file = File.open("./config/maintanance.txt", "r")
          expect( file.read ).to match "メンテナンスのため\n"
         }
      end

    end

    describe 'off' do
      before { 
        file = File.open( './config/maintanance.txt', 'w') 
        Maintainance.off
      }

      it { expect(File.exist?("./config/maintanance.txt")).to be_falsey }
    end
  end
end
