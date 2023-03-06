require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do
  describe 'options_for_select_of_statuses' do
    it 'returns expectedly' do
      expect(helper.options_for_select_of_statuses).to eq([['開始前', 'unstarted'], ['着手中', 'wip'], ['完了', 'done']])
    end
  end

  describe 'options_for_select_of_statuses_with_blank_option' do
    it 'returns expectedly' do
      expect(helper.options_for_select_of_statuses_with_blank_option).to eq([['--未選択--', ''], ['開始前', 'unstarted'], ['着手中', 'wip'], ['完了', 'done']])
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
end
