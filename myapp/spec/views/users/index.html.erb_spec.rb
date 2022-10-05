# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/index', type: :view do
  let(:kuma) { create(:user, name: 'kuma', email: 'kuma@raku.com') }
  let(:nyanko) { create(:user, name: 'nyanko', email: 'nyanko@raku.com') }
  before do
    create(:task, user_id: kuma.id)
    create(:task, user_id: kuma.id)
    create(:task, user_id: nyanko.id)
  end
  let(:users) { Kaminari.paginate_array([kuma, nyanko]).page(1) }

  before { assign(:users, users) }

  it 'renders a list of users' do
    render

    expect(rendered).to match(/ログアウトする/)
    expect(rendered).to match(/新規作成する/)
    expect(rendered).to match(/詳細を確認する/)
    expect(rendered).to match(/編集する/)
    expect(rendered).to match(/削除する/)

    expect(rendered).to match(/kuma/)
    expect(rendered).to match(/kuma@raku.com/)
    expect(rendered).to match(/2/)

    expect(rendered).to match(/nyanko/)
    expect(rendered).to match(/nyanko@raku.com/)
    expect(rendered).to match(/1/)
  end
end
