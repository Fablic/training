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
    subject {
      visit new_label_path
      fill_in :label_name, with: label_name
      click_button I18n.t('common.action.create')
    }

    context 'fill in label_name' do
      let(:label_name) { Faker::Alphanumeric.alphanumeric(number: 5) }
      it 'success create label and redirect to labels_path' do
        expect { subject }.to change(Label, :count).by(1)
        expect(current_path).to eq labels_path
        expect(page).to have_content(label_name)
        expect(page).to have_content(I18n.t('users.flash.success.create'))
      end
    end

    context 'do not fill label_name' do
      let(:label_name) { nil }
      it 'error occurred and render new' do
        expect { subject }.to change(Label, :count).by(0)
        expect(page).to have_content('名前を入力してください')
        expect(page).to have_content(I18n.t('labels.flash.error.create'))
      end
    end
  end

  describe '#edit', :require_login do
    let!(:label) { create(:label) }
    subject {
      visit edit_label_path(label)
      fill_in :label_name, with: new_label_name
      click_button I18n.t('common.action.update')
    }

    context 'fill in label_name' do
      let(:new_label_name) { Faker::Alphanumeric.alphanumeric(number: 5) }
      it 'success create user and redirect to admin_root_path' do
        expect { subject }.to change(Label, :count).by(0)
        expect(current_path).to eq labels_path
        expect(page).to have_content(new_label_name)
        expect(page).to have_content(I18n.t('labels.flash.success.update'))
        expect(page).not_to have_content(label.name)
      end
    end

    context 'do not fill label_name' do
      let(:new_label_name) { nil }

      it 'error occurred and render new' do
        expect { subject }.to change(Label, :count).by(0)
        expect(page).to have_content('名前を入力してください')
        expect(page).to have_content(I18n.t('labels.flash.error.update'))
      end
    end
  end

  describe '#destroy', :require_login do
    let!(:label) { create(:label) }
    subject {
      visit labels_path
      find("a[href='#{label_path(label)}']").click
    }

    context 'click destroy button' do
      it 'sucess destroy and redirect to labels_path' do
        expect { subject }.to change(Label, :count).by(-1)
        expect(current_path).to eq labels_path
        expect(page).to have_content(I18n.t('labels.flash.success.destroy'))
        expect(page).to_not have_content(label.id)
        expect(page).to_not have_content(label.name)
      end
    end
  end
end
