require 'rails_helper'

RSpec.describe "Labels", type: :system do
  let(:user) { User.create(name: "User", username: "user", password: "password123") }
  def log_in(user)
    visit login_path(locale: I18n.locale)
    fill_in I18n.t("username"), with: user.username
    fill_in I18n.t("password"), with: user.password
    click_button I18n.t("button.login")
  end
  before { log_in(user) }

  describe "Listing labels" do
    context "when no labels exist" do
      it "shows no label message" do
        visit labels_path
        expect(page).to have_content(I18n.t 'page.no_label')
      end
    end

    context "when some labels exist" do
      before do
        Label.create!(name: "Label 1", user: user)
        Label.create!(name: "Label 2", user: user)
      end

      it "displays the label list" do
        visit labels_path
        expect(page).to have_content("Label 1")
        expect(page).to have_content("Label 2")
      end
    end
  end
  
  describe "Creating a label" do
    context "with valid name" do
      it "creates a new label" do
        visit new_label_path

        fill_in I18n.t("name"), with: "New Label"
        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t 'msg_create_label_success')
        expect(page).to have_content("New Label")
      end
    end

    context "with invalid name" do
      it "does not create a new label" do
        visit new_label_path

        fill_in I18n.t("name"), with: ""
        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t 'errors.messages.blank')
      end
    end

    context "with a duplicate name" do
      before { Label.create!(name: "Duplicate Label", user: user) }

      it "does not create a new label" do
        visit new_label_path

        fill_in I18n.t("name"), with: "Duplicate Label"
        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t 'errors.messages.taken')
      end
    end
  end

  describe "Editing a label" do
    let!(:label) { Label.create!(name: "Label", user: user) }

    context "with valid name" do
      it "updates the label" do
        visit edit_label_path(locale: I18n.locale, id: label.id)

        fill_in I18n.t("name"), with: "Updated Label"
        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t 'msg_update_label_success')
        expect(page).to have_content("Updated Label")
      end
    end

    context "with invalid name" do
      it "does not update the label" do
        visit edit_label_path(locale: I18n.locale, id: label.id)

        fill_in I18n.t("name"), with: ""
        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t 'errors.messages.blank')
      end
    end

    context "with a duplicate name" do
      before { Label.create!(name: "Duplicate Label", user: user) }

      it "does not update the label" do
        visit edit_label_path(locale: I18n.locale, id: label.id)

        fill_in I18n.t("name"), with: "Duplicate Label"
        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t 'errors.messages.taken')
      end
    end
  end

  describe "Deleting a label" do
    let!(:label) { Label.create!(name: "Delete Me", user: user) }

    it "deletes the label" do
      visit labels_path
      click_link "Delete", href: label_path(locale: I18n.locale, id: label.id)

      expect(page).to have_content(I18n.t 'msg_delete_label_success')
      expect(page).to_not have_content("Delete Me")
    end
  end
end
