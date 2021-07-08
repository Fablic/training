require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do
  describe 'sort_order' do
    context 'リクエストが「期限」の「降順」場合' do
      before do
        def helper.sort_column; end

        def helper.sort_direction; end

        allow(helper).to receive(:sort_column).and_return('limit_date')
        allow(helper).to receive(:sort_direction).and_return('desc')
      end
      it '「期限」の「昇順」のリンクが生成されること' do
        expect(helper.sort_order('limit_date', Task.human_attribute_name(:limit_date))).to eq('<a href="/?direction=asc&amp;sort=limit_date">期限</a>')
      end
    end
  end
end
