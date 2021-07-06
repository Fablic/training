# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :system do
  describe '#index', :require_login do
    before {
      create(:label)
      visit labels_path
    }
    it 'vist tasks/index' do
      expect(current_path).to eq labels_path
      expect(page).to have_content(Label.first.name)
    end
  end

  describe '#new', :require_login do
    let(:label_name) { Faker::Alphanumeric.alphanumeric(number: 5) }
    before {
      visit new_label_path
    }
    it 'success create label and redirect to labels_path' do
      fill_in :label_name, with: label_name

      expect do
        click_button I18n.t('common.action.create')
      end.to change(Label, :count).by(1)
      expect(current_path).to eq labels_path
      expect(page).to have_content(label_name)
      expect(page).to have_content(I18n.t('users.flash.success.create'))
    end
    it 'error occurred and render new' do
      fill_in :label_name, with: nil

      expect do
        click_button I18n.t('common.action.create')
      end.to change(Label, :count).by(0)
      expect(page).to have_content('名前を入力してください')
      expect(page).to have_content(I18n.t('labels.flash.error.create'))
    end
  end
  describe '#edit', :require_login do
    let(:label) { create(:label) }
    let(:new_label_name) { Faker::Alphanumeric.alphanumeric(number: 5) }
    before {
      visit edit_label_path(label)
    }

    it 'success create user and redirect to admin_root_path' do
      fill_in :label_name, with: new_label_name

      expect do
        click_button I18n.t('common.action.update')
      end.to change(Label, :count).by(0)
      expect(current_path).to eq labels_path
      expect(page).to have_content(new_label_name)
      expect(page).to have_content(I18n.t('labels.flash.success.update'))
      expect(page).not_to have_content(label.name)
    end
    it 'error occurred and render new' do
      fill_in :label_name, with: nil

      expect do
        click_button I18n.t('common.action.update')
      end.to change(Label, :count).by(0)
      expect(page).to have_content('名前を入力してください')
      expect(page).to have_content(I18n.t('labels.flash.error.update'))
    end
  end

  describe '#destroy', :require_login do
    let!(:label) { create(:label) }
    it 'sucess destroy and redirect to labels_path' do
      visit labels_path

      expect do
        find("a[href='#{label_path(label)}']").click
      end.to change(Label, :count).by(-1)

      expect(current_path).to eq labels_path
      expect(page).to have_content(I18n.t('labels.flash.success.destroy'))
      expect(page).to_not have_content(label.id)
      expect(page).to_not have_content(label.name)
    end
  end
end
