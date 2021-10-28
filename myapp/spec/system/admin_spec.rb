require 'rails_helper'

RSpec.describe AdminController, type: :system do
  let!(:owner) { create(:user, role: User.roles['owner'], name: 'OWNER') }
  let!(:adminer) { create(:user, role: User.roles['adminer'], name: 'ADMINER') }
  let!(:member) { create(:user, role: User.roles['member'], name: 'MEMBER') }
  let(:task_count) { 10 }
  let(:tasks) { create_list(:task, task_count, user: owner) }

  shared_examples 'The link does not appear in the menu.' do
    it {
      expect(page).not_to have_content(I18n.t('pages.admin.title'))
      expect(page).not_to have_link(I18n.t('pages.admin.users'), href: admin_path)
    }
  end

  shared_examples 'The link will appear in the menu.' do
    it {
      expect(page).to have_content(I18n.t('pages.admin.title'))
      expect(page).to have_link(I18n.t('pages.admin.users'), href: admin_path)
      click_link I18n.t('pages.admin.users')
      expect(page).to have_current_path(admin_path)
    }
  end

  describe '#header' do
    context 'When you are not logged in.' do
      before { visit login_path }
      it_behaves_like 'The link does not appear in the menu.'
    end

    context 'When logged in as member.' do
      before { login_user member }
      it_behaves_like 'The link does not appear in the menu.'
    end

    context 'When logged in as owner.' do
      before { login_user owner }
      it_behaves_like 'The link will appear in the menu.'
    end

    context 'When logged in as adminer.' do
      before { login_user adminer }
      it_behaves_like 'The link will appear in the menu.'
    end
  end

  describe '#index' do
    context 'When you access the site without logging in.' do
      it 'Inaccessible' do
        visit admin_path
        expect(current_path).to eq login_path
      end
    end

    context 'When accessed with member.' do
      it 'Inaccessible' do
        login_user member
        visit admin_path
        expect(current_path).to eq root_path
      end
    end

    context 'When accessed with owner.' do
      it 'The list of users will be displayed.' do
        login_user owner
        visit admin_path
        expect(page).to have_link(owner.name, href: edit_user_path(owner))
        expect(page).to have_content(owner.email)
        expect(page).to have_link(owner.tasks_count, href: tasks_path(user_id: owner.id))
      end
    end

    context 'When accessed with adminer.' do
      it 'The list of users will be displayed.' do
        login_user adminer
        visit admin_path
        expect(page).to have_link(adminer.name, href: edit_user_path(adminer))
        expect(page).to have_content(adminer.email)
        expect(page).to have_link(adminer.tasks_count, href: tasks_path(user_id: adminer.id))
      end
    end

    context 'When a user is deleted.' do
      it 'The user disappears from the list.' do
        login_user owner
        visit admin_path
        expect(page).to have_content(member.email)
        find("#user_delete_button_#{member.id}").click
        expect(page).not_to have_content(member.email)
      end
    end
  end

  describe '#user edit' do
    let(:new_name) { 'New Name' }

    context 'When the adminer edits himself.' do
      it 'Editable.' do
        login_user adminer
        visit edit_user_path(adminer)

        fill_in I18n.t('activerecord.attributes.user.name'), with: new_name
        select I18n.t('activerecord.enum.user.role.owner'), from: I18n.t('activerecord.attributes.user.role')
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('pages.users.flash.edited'))
        expect(page).to have_content(new_name)
      end
    end

    context 'When the adminer edits member.' do
      it 'Editable.' do
        login_user adminer
        visit edit_user_path(member)

        fill_in I18n.t('activerecord.attributes.user.name'), with: new_name
        select I18n.t('activerecord.enum.user.role.owner'), from: I18n.t('activerecord.attributes.user.role')
        click_button I18n.t('common.submit')

        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('pages.users.flash.edited'))
      end
    end

    context 'When the member edits adminer.' do
      it 'Cannot edit.Redirected to root_path.' do
        login_user member
        visit edit_user_path(adminer)
        expect(page).to have_current_path(root_path)
      end
    end
  end

  describe '#tasks ' do
    context 'When an adminer views a members tasks.' do
      it 'Tasks will be displayed.' do
        login_user adminer
        visit tasks_path(user_id: member.id)
        expect(page).to have_content(member.name)
      end
    end
    context 'When an member views a adminer tasks.' do
      it 'Tasks will not be displayed.' do
        login_user member
        visit tasks_path(user_id: adminer.id)
        expect(page).not_to have_content(adminer.name)
        expect(page).to have_content(member.name)
      end
    end
  end
end
