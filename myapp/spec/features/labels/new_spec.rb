# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/admin/label/new' do
  feature '#new' do
    before(:each) { login(user) }

    given(:user) { create(:user, role: 'admin') }

    scenario 'correctly displays label new form' do
      visit new_label_path

      expect(current_path).to eq '/labels/new'
    end

    scenario 'renders #index' do
      visit new_label_path
      click_on '一覧に戻る'

      expect(current_path).to eq '/labels'
      expect(page).to have_content 'ラベル一覧'
    end

    scenario 'creates new label' do
      visit new_label_path

      expect(current_path).to eq '/labels/new'

      fill_in 'ラベル名', with: 'aqua'

      expect { click_button '登録する' }.to change(Label, :count).by(1)
      expect(Label.last.name).to eq 'aqua'
      expect(current_path).to eq labels_path
      expect(page).to have_content 'ラベルが正常に作成されました'
    end

    scenario 'does NOT create without name' do
      visit new_label_path

      expect(current_path).to eq '/labels/new'

      fill_in 'ラベル名', with: ''

      expect { click_button '登録する' }.to change(Label, :count).by(0)
      expect(current_path).to eq labels_path
      expect(page).to have_content '1件のエラーが発生しました'
      expect(page).to have_content 'ラベル名を入力してください'
    end

    scenario 'does NOT create with 31 over words name' do
      visit new_label_path

      expect(current_path).to eq '/labels/new'

      fill_in 'ラベル名', with: 'a' * 31

      expect { click_button '登録する' }.to change(Label, :count).by(0)
      expect(current_path).to eq labels_path
      expect(page).to have_content '1件のエラーが発生しました'
      expect(page).to have_content 'ラベル名は30文字以内で入力してください'
    end
  end
end
