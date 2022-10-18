# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/label/:id/edit' do
  feature '#edit' do
    before(:each) { login(user) }

    given(:user) { create(:user, role: 'admin') }
    given(:label) { create(:label) }

    scenario 'renders #index' do
      visit edit_label_path(label)
      click_on '一覧に戻る'

      expect(current_path).to eq '/labels'
      expect(page).to have_content 'ラベル一覧'
    end

    scenario 'correctly updates edit label' do
      visit edit_label_path(label)

      expect(current_path).to eq "/labels/#{label.id}/edit"

      fill_in 'ラベル名', with: 'うぷだてラベルやで'

      expect { click_button '更新する' }.to \
        change { Label.exists?(name: 'うぷだてラベルやで') }.from(false).to(true)
      expect(current_path).to eq labels_path
      expect(page).to have_content 'ラベルが正常に更新されました'
    end

    scenario 'does NOT update with empty name' do
      visit edit_label_path(label)

      expect(current_path).to eq "/labels/#{label.id}/edit"

      fill_in 'ラベル名', with: ''

      expect { click_button '更新する' }.to change(Label, :count).by(0)
      expect(current_path).to eq "/labels/#{label.id}"
      expect(page).to have_content '1件のエラーが発生しました'
      expect(page).to have_content 'ラベル名を入力してください'
    end

    scenario 'does NOT update with 31 over words name' do
      visit edit_label_path(label)

      expect(current_path).to eq "/labels/#{label.id}/edit"

      fill_in 'ラベル名', with: 'a' * 31

      expect { click_button '更新する' }.to change(Label, :count).by(0)
      expect(current_path).to eq "/labels/#{label.id}"
      expect(page).to have_content '1件のエラーが発生しました'
      expect(page).to have_content 'ラベル名は30文字以内で入力してください'
    end
  end

  feature '#edit without admin' do
    before { login create(:user, role: 'ordinary') }
    given(:label) { create(:label) }

    scenario 'redirects #index' do
      visit edit_label_path(label)

      expect(current_path).to eq labels_path
      expect(page).to have_content '権限がないため編集ページを開くことが出来ません'
    end
  end
end
