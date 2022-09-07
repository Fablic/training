describe 'ページング機能' do
  context 'タスク5件以内' do
    before do
      FactoryBot.create(:task, title: 'title_one')
      FactoryBot.create(:task, title: 'title_two')
      FactoryBot.create(:task, title: 'title_three')
      FactoryBot.create(:task, title: 'title_four')
      FactoryBot.create(:task, title: 'title_five')
    end

    it 'ページングが表示されないこと 1' do
      visit root_path
      expect(find('div.pagenation')).not_to have_content '1'
    end

    it 'ページングが表示されないこと 2' do
      visit root_path
      expect(find('div.pagenation')).not_to have_content '2'
    end

    it 'ページングが表示されないこと Next' do
      visit root_path
      expect(find('div.pagenation')).not_to have_content 'Next'
    end

    it 'ページングが表示されないこと Last' do
      visit root_path
      expect(find('div.pagenation')).not_to have_content 'Last'
    end
  end

  context 'タスク11件' do
    before do
      FactoryBot.create(:task, title: 'title_one')
      FactoryBot.create(:task, title: 'title_two')
      FactoryBot.create(:task, title: 'title_three')
      FactoryBot.create(:task, title: 'title_four')
      FactoryBot.create(:task, title: 'title_five')
      FactoryBot.create(:task, title: 'title_six')
      FactoryBot.create(:task, title: 'title_seven')
      FactoryBot.create(:task, title: 'title_eight')
      FactoryBot.create(:task, title: 'title_nine')
      FactoryBot.create(:task, title: 'title_ten')
      FactoryBot.create(:task, title: 'title_eleven')
    end

    it 'ページングが表示されること 1' do
      visit root_path
      expect(find('div.pagenation')).to have_content '1'
    end

    it 'ページングが表示されること 2' do
      visit root_path
      expect(find('div.pagenation')).to have_content '2'
    end

    it 'ページングが表示されること Next' do
      visit root_path
      expect(find('div.pagenation')).to have_content 'Next'
    end

    it 'ページングが表示されること Last' do
      visit root_path
      expect(find('div.pagenation')).to have_content 'Last'
    end

    it '「2」を押下すると6件目のタスクが表示されること' do
      visit root_path
      click_on '2'
      expect(page).to have_content 'title_six'
    end

    it '「Next」を押下すると6件目のタスクが表示されること' do
      visit root_path
      click_on 'Next'
      expect(page).to have_content 'title_six'
    end

    it '「Last」を押下すると11件目のタスクが表示されること' do
      visit root_path
      click_on 'Last'
      expect(page).to have_content 'title_eleven'
    end

    it '「First」を押下すると1件目のタスクが表示されること' do
      visit root_path
      click_on 'Last'
      click_on 'First'
      expect(page).to have_content 'title_one'
    end

    it '「Last」を押下後に「Previous」を押下すると6件目のタスクが表示されること' do
      visit root_path
      click_on 'Last'
      click_on 'Previous'
      expect(page).to have_content 'title_six'
    end
  end
end
end
