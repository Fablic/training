require 'rails_helper'

RSpec.describe 'Users', type: :system do 
  before do
    @admin_user = User.create(
      username: 'admin_user',
      password: 'password',
      admin: true
    )

    @normal_user = User.create(
      username: 'normal_user',
      password: 'password',
      admin: false
    )

    visit login_path 

    fill_in 'username', with: 'admin_user'
    fill_in 'password', with: 'password'
    click_on 'commit'
  end
  
  describe 'admin page' do 
    it 'admin user should get access to admin page' do 
      visit admin_path

      expect(current_path).to eq(admin_path)
    end

    it 'normal user should not get access to admin page' do 
      click_on I18n.t('views.buttons.logout')

      fill_in 'username', with: 'normal_user'
      fill_in 'password', with: 'password'
      click_on 'commit'

      visit admin_path 

      expect(current_path).to eq(tasks_path)
      expect(page).to have_content('No permissioin to access admin page!')
    end

    it 'should show admin permission for each user' do 
      visit admin_path 

      users = find('tbody').all('tr')

      expect(users[0]).to have_content('◯')
      expect(users[1]).to_not have_content('◯')
    end

    it 'should jump to edit page when clicking user name' do 
      visit admin_path 

      click_on @admin_user.username 

      expect(current_path).to eq(edit_user_path(@admin_user))
    end

    it 'should jump to user"s tasks page when clicking number of tasks' do 
      visit admin_path

      first_row = find('tbody').all('tr')[0]
      first_row.all('td')[3].find('a').click

      expect(current_path).to eq(user_tasks_path(@admin_user))
    end
    
    it 'should delete user when clicking delete button' do 
      visit admin_path
      
      users = find('tbody').all('tr')

      second_row = users[1]
      second_row.all('td')[4].find("input[value='#{I18n.t('views.buttons.delete')}']").click

      expect(users).to_not have_content(@normal_user.username)
    end


  end

  describe 'admin edit page' do 
    it 'should have two forms and not be able to self-select role' do 
      visit edit_user_path(@admin_user)

      expect(page).to have_button('commit', count: 2)

      expect(page).to have_selector('input[id="user_admin_false"][disabled]')
      expect(page).to have_selector('input[id="user_admin_true"][disabled]')
    end
  end

  describe 'mantenance feature' do 
    before do 
      Rails.application.load_tasks
      @tmp_file_path = Rails.root.join('tmp', 'maintenance_tmp.txt')
    end

    it 'should create and delete a tmp file when start and end task executed' do
      Rake::Task['maintenance:start'].invoke 
      assert_equal(File.exist?(@tmp_file_path), true)
      Rake::Task['maintenance:start'].reenable

      Rake::Task['maintenance:end'].invoke 
      assert_equal(File.exist?(@tmp_file_path), false)
      Rake::Task['maintenance:start'].reenable
    end

    context 'when in maintenance mode' do 
      it 'should be able to visit task page if is admin user' do 
        Rake::Task['maintenance:start'].invoke 
        Rake::Task['maintenance:start'].reenable
  
        visit current_path

        expect(page).to have_content(I18n.t('views.titles.task_list'))

        Rake::Task['maintenance:end'].invoke
        Rake::Task['maintenance:start'].reenable
      end
  
      it 'should render 503 page if is normal user' do 
        click_on I18n.t('views.buttons.logout')
  
        fill_in 'username', with: 'normal_user'
        fill_in 'password', with: 'password'
        click_on 'commit'      
  
        Rake::Task['maintenance:start'].invoke 
        Rake::Task['maintenance:start'].reenable
  
        visit current_path
  
        expect(page).to have_content('503')
        expect(page).to have_content('Server is in maintenance now.')
        expect(page).to have_content('Please wait until service turns to be available.')

        Rake::Task['maintenance:end'].invoke
        Rake::Task['maintenance:start'].reenable
      end
    end
  end
end
