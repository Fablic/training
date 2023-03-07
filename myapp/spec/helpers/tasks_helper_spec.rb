require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do
  describe 'options_for_select_of_statuses' do
    it 'returns expectedly' do
      expect(helper.options_for_select_of_statuses).to eq([['開始前', 'unstarted'], ['着手中', 'wip'], ['完了', 'done']])
    end
  end

  describe 'value_with_i18n' do
    let(:task) { create(:task, name: 'hoge_task', status: 'done') }

    context 'attributes except for status' do
      it 'returns as it is' do
        expect(helper.value_with_i18n(task, 'name')).to eq('hoge_task')
      end
    end

    context 'status attribute' do
      it 'returns converted value by i18n' do
        expect(helper.value_with_i18n(task, 'status')).to eq('完了')
      end
    end
  end

  describe 'badge_class' do
    context 'status is unstarted' do
      it 'returns expected value' do
        expect(helper.badge_class('unstarted')).to eq('badge py-2 fs-6 bg-primary')
      end
    end

    context 'status is wip' do
      it 'returns expected value' do
        expect(helper.badge_class('wip')).to eq('badge py-2 fs-6 bg-danger')
      end
    end

    context 'status is done' do
      it 'returns expected value' do
        expect(helper.badge_class('done')).to eq('badge py-2 fs-6 bg-success')
      end
    end

    context 'status is unknown' do
      it 'returns expected value' do
        expect(helper.badge_class('hoge')).to eq('badge py-2 fs-6 bg-secondary')
      end
    end
  end
end
