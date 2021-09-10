# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminHelper, type: :helper do
  describe 'method' do
    describe '#admin_screen?' do
      let(:request) { double('request', fullpath: fullpath) }
      before { allow(helper).to receive(:request).and_return(request) }
      subject { admin_screen? }

      context 'admin以外のページにリクエストを送る' do
        let(:fullpath) { '/users/2' }
        it { is_expected.to be_falsey }
      end

      context 'adminページにリクエストを送る' do
        let(:fullpath) { '/admin/users/2' }
        it { is_expected.to be_truthy }
      end
    end
  end
end
