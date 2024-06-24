require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'Userlist' do
    shared_examples 'Checking component' do
      it 'displays common components' do
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
        expect(page).to have_link(I18n.t('views.common.add'))
      end
    end

    context 'When no users exist' do
      before do
        visit users_path
      end

      it_behaves_like 'Checking component'
      it 'displays "no users" message' do
        expect(page).to have_content(I18n.t('views.users.index.no_users'))
      end
    end

    context 'When any users exist' do
      before do
        @user1 = create(:user, username: 'User1', password: 'password1')
        @user2 = create(:user, username: 'User2', password: 'password2', role: :member)
        @user3 = create(:user, username: 'User3', password: 'password3', role: :admin)

        visit users_path
      end

      it_behaves_like 'Checking component'
      it 'displays Items in the correct order' do
        expect(find('tbody tr:nth-child(1)')).to have_link(@user1.username)
        expect(find('tbody tr:nth-child(2)')).to have_link(@user2.username)
        expect(find('tbody tr:nth-child(3)')).to have_link(@user3.username)
        expect(page).to have_selector('tbody tr:nth-child(1)', text: I18n.t(%(activerecord.attributes.user.roles.member)))
        expect(page).to have_selector('tbody tr:nth-child(2)', text: I18n.t(%(activerecord.attributes.user.roles.member)))
        expect(page).to have_selector('tbody tr:nth-child(3)', text: I18n.t(%(activerecord.attributes.user.roles.admin)))
      end
    end
  end

  describe 'New user' do
    context 'Initial display' do
      before do
        visit users_path
        click_link I18n.t('views.common.add')
      end

      it 'display components' do
        expect(page).to have_selector('h1', text: I18n.t('views.users.new.title'))
        expect(page).to have_field(I18n.t('helpers.label.user.username'), readonly: false)
        expect(page).to have_field(I18n.t('helpers.label.user.password'), readonly: false)
        expect(page).to have_link(I18n.t('views.common.cancel'))
        expect(page).to have_button(I18n.t('helpers.submit.create'))
      end
    end

    context 'When cancelling' do
      before do
        visit new_user_path
        click_link I18n.t('views.common.cancel')
      end

      it 'goes back to the User page' do
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
      end
    end

    context 'When the user is valid' do
      let(:valid_params) { { username: '全' * 25, password: '角' * 10 } }

      before do
        visit new_user_path
        fill_in I18n.t('helpers.label.user.username'), with: valid_params[:username]
        fill_in I18n.t('helpers.label.user.password'), with: valid_params[:password]
        click_button I18n.t('helpers.submit.create')
      end

      it 'shows a success message on the Users page' do
        expect(User.count).to eq(1)
        expect(User.last.username).to eq(valid_params[:username])
        expect(User.last.authenticate(valid_params[:password])).to be_truthy
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.create')))
      end
    end

    context 'When the user is invalid' do
      before do
        visit new_user_path
        fill_in I18n.t('helpers.label.user.username'), with: '  '
        fill_in I18n.t('helpers.label.user.password'), with: 'N' * 4
        click_button I18n.t('helpers.submit.create')
      end
      it 'shows a error message on the New page' do
        expect(User.count).to eq(0)
        expect(page).to have_selector('h1', text: I18n.t('views.users.new.title'))
        expect(page).to have_content(I18n.t('flash.common.failure', model: I18n.t('actions.create')))
        expect(page).to have_content(I18n.t('activerecord.attributes.user.username') + I18n.t('activerecord.errors.messages.blank'))
        expect(page).to have_content(I18n.t('activerecord.attributes.user.password') + I18n.t('activerecord.errors.messages.too_short', count: 5))
      end
    end
  end

  describe 'Show user' do
    let!(:user) { create(:user, username: 'User$$$', password: 'P@ssW0rD') }

    context 'Initial display' do
      before do
        visit users_path
        click_link user.username
      end
      it 'display components' do
        expect(page).to have_selector('h1', text: I18n.t('views.users.show.title'))
        expect(page).to have_field(I18n.t('helpers.label.user.username'), with: user.username, readonly: true)
        expect(page).to have_field(I18n.t('helpers.label.user.password'), readonly: true)
        expect(page).to have_link(I18n.t('views.common.cancel'))
        expect(page).to have_link(I18n.t('views.common.edit'))
      end
    end

    context 'When cancelling' do
      before do
        visit user_path(user)
        click_link I18n.t('views.common.cancel')
      end

      it 'goes back to the User page' do
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
      end
    end

    context 'When deleting the User' do
      before do
        visit user_path(user)
        click_button I18n.t('views.common.delete')
      end

      it 'shows a success message on the Users page' do
        expect(User.count).to eq(0)
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.destroy')))
      end
    end
  end

  describe 'Edit user' do
    let!(:user) { create(:user, username: 'User$$$', password: 'P@ssW0rD') }

    context 'Initial display' do
      before do
        visit user_path(user)
        click_link I18n.t('views.common.edit')
      end
      it 'display components' do
        expect(page).to have_selector('h1', text: I18n.t('views.users.edit.title'))
        expect(page).to have_field(I18n.t('helpers.label.user.username'), with: user.username, readonly: false)
        expect(page).to have_field(I18n.t('helpers.label.user.password'), readonly: false)
        expect(page).to have_link(I18n.t('views.common.cancel'))
        expect(page).to have_button(I18n.t('helpers.submit.update'))
      end
    end

    context 'When cancelling' do
      before do
        visit edit_user_path(user)
        click_link I18n.t('views.common.cancel')
      end

      it 'goes back to the User page' do
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
      end
    end

    context 'When deleting the User' do
      before do
        visit edit_user_path(user)
        click_button I18n.t('views.common.delete')
      end

      it 'shows a success message on the Users page' do
        expect(User.count).to eq(0)
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.destroy')))
      end
    end

    context 'When updating the User with valid data' do
      let(:valid_params) { { username: '全' * 25, password: '角' * 10 } }
      before do
        visit edit_user_path(user)
        fill_in I18n.t('helpers.label.user.username'), with: valid_params[:username]
        fill_in I18n.t('helpers.label.user.password'), with: valid_params[:password]
        click_button I18n.t('helpers.submit.update')
      end

      it 'shows a success message on the Users page' do
        expect(User.count).to eq(1)
        expect(User.last.username).to eq(valid_params[:username])
        expect(User.last.authenticate(valid_params[:password])).to be_truthy
        expect(page).to have_selector('h1', text: I18n.t('views.users.index.title'))
        expect(page).to have_content(I18n.t('flash.common.success', model: I18n.t('actions.update')))
      end
    end

    context 'When updating the User with invalid data' do
      before do
        visit edit_user_path(user)
        fill_in I18n.t('helpers.label.user.username'), with: 'A' * 26
        fill_in I18n.t('helpers.label.user.password'), with: 'NG Case'
        click_button I18n.t('helpers.submit.update')
      end

      it 'shows a error message on the Edit page' do
        expect(User.count).to eq(1)
        expect(page).to have_selector('h1', text: I18n.t('views.users.edit.title'))
        expect(page).to have_content(I18n.t('flash.common.failure', model: I18n.t('actions.update')))
        expect(page).to have_content(I18n.t('activerecord.attributes.user.username') + I18n.t('activerecord.errors.messages.too_long', count: 25))
      end
    end
  end
end
