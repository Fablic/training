require 'rails_helper'
describe 'Tasks', type: :system do
    describe '#list', type: :system do
        include TaskHelper
        before do
            # データ作成
            user = User.create!(name: 'name1')
            @task = nil
            tasks_count.times do |i|
                @task = Task.create!(
                    title: "title#{i + 1}",
                    description: "description#{i + 1}",
                    user_id: user[:id],
                    status: '1',
                    label: "label#{i + 1}"
                )
            end
            # 画面設定
            visit(tasks_path())
            # DBからデータ取得
            @tasks = Task.all
            # 画面の一覧取得
            @trs = all('tbody tr')
        end
        # 一覧の項目比較
        shared_examples_for 'compare_list_task' do
            it {
                # 項目比較
                expect(@trs.size).to(eq(@tasks.size))
                @trs.size.times do |i|
                    columns = @trs[i].all('td')
                    expect(columns[0]).to(have_content(@tasks[i].title))
                    expect(columns[1]).to(have_content(@tasks[i].label))
                end
            }
        end
        # 削除
        shared_examples_for 'delete_task' do
            it {
                # 画面設定
                visit(tasks_path())
                # 削除
                expect{ find_by_id("delete#{@task.id}").click }.to change(Task, :count).by(-1)
                expect(
                    Task.find_by(
                        title: @task.title,
                        description: @task.description,
                        label: @task.label,
                        user_id: @task.user_id
                    )
                ).to be nil
            }
        end
        context 'Taskが0件の場合' do
            let!(:tasks_count) { 0 }
            it_behaves_like 'compare_list_task'
        end
        context 'Taskが1件の場合' do
            let!(:tasks_count) { 1 }
            it_behaves_like 'compare_list_task'
            it_behaves_like 'delete_task'
        end
        context 'Taskが複数件の場合' do
            let!(:tasks_count) { 5 }
            it_behaves_like 'compare_list_task'
            it_behaves_like 'delete_task'
        end
    end
    describe '#new', type: :system do
        before do
            # User作成
            @user = User.create!(name: 'name1')
            # 画面遷移
            visit(tasks_new_path())
            # 新規タスク登録
            fill_in('task[title]', with: new_task[:title])
            fill_in('task[description]', with: new_task[:description])
            fill_in('task[label]', with: new_task[:label])
            find("option[value='#{@user.id}']").select_option
            # タスク登録確認
            expect{ click_button 'Create' }.to change(Task, :count).by(1)
            # 登録データ確認
            @task = Task.find_by(
                title: new_task[:title],
                description: new_task[:description],
                label: new_task[:label]
            )
        end
        # 登録データの項目比較
        shared_examples_for 'compare_new_item' do
            it {
                # 項目比較
                expect(@task.title).to eq(new_task[:title])
                expect(@task.description).to eq(new_task[:description])
                expect(@task.label).to eq(new_task[:label])
                expect(@task.user_id).to eq(@user[:id])
            }
        end
        context '全項目入力した場合' do
            let!(:new_task) { {
                :title => 'new title',
                :description => 'new description',
                :label => 'new label',
                :user_id => @user.id
            } }
            it_behaves_like 'compare_new_item'
        end
        context 'タイトルのみ入力した場合' do
            let!(:new_task) { {
                :title => 'new title',
                :description => '',
                :label => '',
                :user_id => @user.id
            } }
            it_behaves_like 'compare_new_item'
        end
        context '内容のみ入力した場合' do
            let!(:new_task) { {
                :title => '',
                :description => 'new description',
                :label => '',
                :user_id => @user.id
            } }
            it_behaves_like 'compare_new_item'
        end
        context 'ラベルのみ入力した場合' do
            let!(:new_task) { {
                :title => '',
                :description => '',
                :label => 'new label',
                :user_id => @user.id
            } }
            it_behaves_like 'compare_new_item'
        end
    end
    describe '#show', type: :system do
        before do
            # User作成
            user = User.create!(name: 'name1')
            # Task作成
            @task = Task.create!(
                title: "title1",
                description: "description1",
                user_id: user[:id],
                status: '1',
                label: "label1"
            )
            # DBからデータ取得
            @db_task = Task.joins(:user).select('tasks.title, tasks.description, tasks.label, users.name, tasks.status').where(id: @task.id).first
        end
        # 項目比較
        shared_examples_for 'compare_task' do
            it {
                # 画面遷移
                visit(tasks_show_path(@task))
                # 項目比較
                expect(page).to(have_content(@db_task.title))
                expect(page).to(have_content(@db_task.description))
                expect(page).to(have_content(@db_task.label))
                expect(page).to(have_content(@db_task.name))
            }
        end
        context '通常ケース' do
            it_behaves_like 'compare_task'
        end
    end
    describe '#edit', type: :system do
        include TaskHelper
        # 事前処理
        before do
            # User作成
            @user1 = User.create!(name: 'name1')
            @user2 = User.create!(name: 'name2')
            # Task作成
            @task = Task.create!(
                title: "title1",
                description: "description1",
                user_id: @user1.id,
                status: '1',
                label: "label1"
            )
            # 画面遷移
            visit(tasks_edit_path(@task))
            # DBからデータ取得
            @before_task = Task.find(@task.id)
            # 更新
            if defined? update_task
                fill_in 'task[title]', with: update_task[:title]
                fill_in 'task[description]', with: update_task[:description]
                fill_in 'task[label]', with: update_task[:label]
                select(value = update_task[:user_name], from: 'task[user_id]')
                click_button 'Update'
            end
            # DBからデータ取得
            @after_task = Task.find(@task.id)
        end
        # 項目比較
        shared_examples_for 'compare_update_task' do
            it {
                # 項目比較
                expect(@after_task.title).to eq(update_task[:title])
                expect(@after_task.description).to eq(update_task[:description])
                expect(@after_task.label).to eq(update_task[:label])
                expect(@after_task.user_id).to eq(update_task[:user_id])
            }
        end
        context '初期表示の場合' do
            it 'DBから取得した値と一致' do
                # 画面遷移
                visit(tasks_edit_path(@task))
                # 項目比較
                expect(page).to(have_field('task[title]', with: @before_task[:title]))
                expect(page).to(have_field('task[description]', with: @before_task[:description]))
                expect(page).to(have_field('task[label]', with: @before_task[:label]))
                expect(page).to(have_select('task[user_id]', selected: @user1.name))
            end
        end
        context '全項目変更' do
            let!(:update_task) { {
                :title => 'update title',
                :description => 'update description',
                :label => 'update label',
                :status => '2',
                :user_id => @user2.id,
                :user_name => @user2.name
            } }
            # 表示確認
            it_behaves_like 'compare_update_task'
        end
        context 'タイトルのみ変更' do
            let!(:update_task) { {
                :title => 'update title',
                :description => 'description1',
                :label => 'label1',
                :status => '1',
                :user_id => @user1.id,
                :user_name => @user1.name
            } }
            # 表示確認
            it_behaves_like 'compare_update_task'
        end
        context '内容のみ変更' do
            let!(:update_task) { {
                :title => 'title1',
                :description => 'update description',
                :label => 'label1',
                :status => '1',
                :user_id => @user1.id,
                :user_name => @user1.name
            } }
            # 表示確認
            it_behaves_like 'compare_update_task'
        end
        context 'ラベルのみ変更' do
            let!(:update_task) { {
                :title => 'title1',
                :description => 'description1',
                :label => 'update label',
                :status => '1',
                :user_id => @user1.id,
                :user_name => @user1.name
            } }
            # 表示確認
            it_behaves_like 'compare_update_task'
        end
        context 'ステータスのみ変更' do
            let!(:update_task) { {
                :title => 'title1',
                :description => 'description1',
                :label => 'label1',
                :status => '2',
                :user_id => @user1.id,
                :user_name => @user1.name
            } }
            # 表示確認
            it_behaves_like 'compare_update_task'
        end
        context 'ユーザのみ変更' do
            let!(:update_task) { {
                :title => 'title1',
                :description => 'description1',
                :label => 'label1',
                :status => '1',
                :user_id => @user1.id,
                :user_name => @user1.name
            } }
            # 表示確認
            it_behaves_like 'compare_update_task'
        end
    end
end
