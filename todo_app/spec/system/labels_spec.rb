# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Labels', type: :system do
  describe '一覧画面', :require_login do
    context '正常時' do
      let!(:label) { create(:label) }
      let!(:label2) { create(:label, name: 'ラベル2', color: :warning) }

      it 'ラベル一覧が表示されていること' do
        visit labels_path

        expect(page).to have_content 'ラベル'
        expect(page).to have_css '.bg-info'

        expect(page).to have_content 'ラベル2'
        expect(page).to have_css '.bg-warning'
      end
    end

    context '未登録時' do
      it 'ラベル一覧が表示されていないこと' do
        visit labels_path

        expect(page).to have_content 'Lets register your a label'
      end
    end
  end

  describe '新規作成画面', :require_login do
    context '正常時' do
      it 'ラベルが作成できること' do
        visit new_label_path
        fill_in 'label_name', with: 'hogehoge'
        select 'success', from: 'label_color'
        click_button 'Create'

        expect(page).to have_content 'hogehoge'
        expect(page).to have_css '.bg-success'
      end
    end

    context '必須項目が抜けている時' do
      it 'ラベルが作成失敗すること' do
        visit new_label_path
        fill_in 'label_name', with: ''
        click_button 'Create'

        expect(page).to have_content 'Registered is failed'
        expect(page).to have_content "Name can't be blank"
      end
    end

    context 'ラベル名の重複時' do
      let!(:label) { create(:label) }

      it 'ラベルが作成失敗すること' do
        visit new_label_path
        fill_in 'label_name', with: 'ラベル'
        click_button 'Create'

        expect(page).to have_content 'Registered is failed'
        expect(page).to have_content 'Name has already been taken'
      end
    end
  end

  describe '削除機能', :require_login do
    let!(:label) { create(:label) }

    context '正常時' do
      it '削除ができること' do
        visit edit_label_path(label)
        click_link 'Delete'

        expect(page).to_not have_content 'ラベル'
        expect(current_path).to match labels_path
      end
    end
  end

  describe '編集画面', :require_login do
    let!(:label) { create(:label) }

    context '正常時' do
      it '編集ができること' do
        visit edit_label_path(label)
        fill_in 'label_name', with: 'hogehogehoge'
        select 'success', from: 'label_color'
        click_button 'Edit'

        expect(page).to have_content 'hogehogehoge'
        expect(page).to have_css '.bg-success'
      end
    end

    context 'ラベル名の重複時' do
      let!(:label) { create(:label) }
      let!(:label2) { create(:label, name: 'ラベル2') }

      it 'ラベルが作成失敗すること' do
        visit edit_label_path(label2)
        fill_in 'label_name', with: 'ラベル'
        click_button 'Edit'

        expect(page).to have_content 'Edited is failed'
        expect(page).to have_content 'Name has already been taken'
      end
    end
  end
end
