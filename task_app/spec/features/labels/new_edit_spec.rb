# frozen_string_literal: true

require 'rails_helper'

shared_examples_for '正常処理とバリデーションエラーの確認' do
  before do
    fill_in 'ラベル名', with: label_name
    click_on('送信')
  end

  context '正常値を入力したとき' do
    let(:label_name) { 'ダミーラベル' }

    scenario '正常に処理される' do
      expect(page).to have_selector '.alert-success'
      expect(page).to have_no_selector '#error_explanation'
      expect(page).to have_content 'ダミーラベル'
      expect(page.all('tbody tr').size).to eq 1
      expect(Label.count).to eq 1
    end
  end

  context '空欄のまま送信したとき' do
    let(:label_name) { '' }

    scenario '入力を促すエラーメッセージが表示される' do
      expect(page).to have_selector '#error_explanation', text: 'ラベル名を入力してください'
    end
  end

  context '制限内の文字数を入力したとき' do
    let(:label_name) { 'a' * 20 }

    scenario '正常に処理される' do
      expect(page).to have_no_selector '#error_explanation'
      expect(page).to have_selector '.alert-success'
    end
  end

  context '制限外の文字数を入力したとき' do
    let(:label_name) { 'a' * 21 }

    scenario '文字数に関するエラーメッセージが表示される' do
      expect(page).to have_no_selector '.alert-success'
      expect(page).to have_selector '#error_explanation', text: '20文字以内'
    end
  end
end

feature 'ラベル登録・編集', type: :feature do
  let!(:user) { FactoryBot.create(:user, role: :admin) }

  before { login(user) }

  feature 'ラベル登録画面(機能)' do
    before { visit new_admin_label_path }

    context 'タスク一覧画面からボタンクリックで画面遷移したとき' do
      before do
        visit root_path
        page.find('.navbar-toggler').click
        page.find('#navbarLabelMenuLink').click
        page.click_link('ラベル登録')
      end

      scenario 'ラベル登録画面に遷移する' do
        expect(current_path).to eq new_admin_label_path
      end
    end

    it_behaves_like '正常処理とバリデーションエラーの確認'
  end

  feature 'ラベル編集機能' do
    let!(:label) { FactoryBot.create(:label) }

    before do
      visit admin_labels_path
      click_on('編集')
    end

    it_behaves_like '正常処理とバリデーションエラーの確認'
  end
end
