require 'rails_helper'

RSpec.describe TasksController, type: :controller do

    shared_examples_for "レスポンス(HTTPステータスコード)が正しいこと" do |status|
        it { subject.call; expect(response).to have_http_status(status) }
    end

    shared_examples_for "想定エラーが発生すること" do |error|
        it { 
            expect { subject.call }.to raise_error(error)
            expect(response.response_code).to eq(200)
        }
    end

    describe "GET #index" do
        subject {Proc.new { get :index }}
        let!(:tasks) { create_list(:task, listnum) }
        let(:listnum) { 5 }
        it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200

        it "タスクが作成日時(降順)で並び替えられた状態で全件取得できていること" do
            addDays = 0
            for task in tasks do
                task.update(created_at: Date.today + addDays)
                addDays += 1
            end
            
            subject.call
            displayed_tasks = controller.instance_variable_get('@tasks')
            
            expect(displayed_tasks.size).to be == listnum
            before_task = nil
            for task in displayed_tasks do
                if before_task then
                    expect(task.created_at).to be <= before_task.created_at
                end
                before_task = task
            end
        end
    end

    describe "GET #new" do
        subject {Proc.new { get :new }}
        it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200
    end

    describe "GET #show" do
        subject {Proc.new { get :show, params: { id: id } }}
        let!(:task) { create(:task) }
        context "該当するタスクが存在する場合" do
            context "有効なパラメータの場合" do
                let(:id) { task.id }
                it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200
            end
            context "無効なパラメータの場合" do
                let(:id) { nil }
                it_behaves_like "想定エラーが発生すること", ActionController::UrlGenerationError
            end
        end
        context "該当するタスクが存在しない場合" do
            let(:id) { Task.last.id + 1 }
            it_behaves_like "想定エラーが発生すること", ActiveRecord::RecordNotFound
        end
    end

    describe "GET #edit" do
        subject {Proc.new { get :edit, params: { id: id } }}
        let!(:task) { create(:task) }
        context "該当するタスクが存在する場合" do
            context "有効なパラメータの場合" do
                let(:id) { task.id }
                it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200
            end
            context "無効なパラメータの場合" do
                let(:id) { nil }
                it_behaves_like "想定エラーが発生すること", ActionController::UrlGenerationError
            end
        end
        context "該当するタスクが存在しない場合" do
            let(:id) { Task.last.id + 1 }
            it_behaves_like "想定エラーが発生すること", ActiveRecord::RecordNotFound
        end
    end

    describe "POST #create" do
        subject {Proc.new { post :create, params: { task: task } }}
        context "有効なパラメータの場合" do
            let(:task){attributes_for(:task, title: "test_title_create")}

            it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと",302

            it "タスクが作成されること" do
                expect { subject.call }.to change(Task, :count).by(1)
                expect(Task.find(Task.last.id).title).to eq("test_title_create")
            end

            it "作成したタスク詳細画面へリダイレクトされ、フラッシュメッセージが表示されること" do
                subject.call
                expect(response).to redirect_to "/#{Task.last.id}"
                expect(flash[:notice]).to match(/^タスクを作成しました！$/)
            end
        end
        context "無効なパラメータの場合" do
            let(:task){attributes_for(:task, title: nil)}
            it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200
            it "タスクが作成されないこと" do
                expect { subject.call }.to change(Task, :count).by(0)
            end
        end
    end

    describe "PATCH #update" do
        subject {Proc.new { patch :update, params: {id: id, task: {title: value}} }}
        let!(:task) { create(:task) }
        context "該当するタスクが存在する場合" do
            let(:id) { task.id }

            context "有効なパラメータの場合" do
                let(:value) { "updated_task" }
                it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと",302
                
                it "タスク情報が更新されること" do
                    subject.call
                    expect(task.reload.title).to eq "updated_task"
                end

                it "更新したタスク詳細画面へリダイレクトされ、フラッシュメッセージが表示されること" do
                    subject.call
                    expect(response).to redirect_to "/#{task.id}"
                    expect(flash[:notice]).to match(/^タスクを更新しました！$/)
                end
            end
            context "無効なパラメータの場合" do
                let(:value){ nil }
                it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200
                
                it "タスク情報が更新されないこと" do
                    subject.call
                    expect(task.reload.title).not_to eq nil
                end
            end
        end
        context "該当するタスクが存在しない場合" do
            let(:id) { Task.last.id + 1 }
            let(:value) { "updated_task" }
            it_behaves_like "想定エラーが発生すること", ActiveRecord::RecordNotFound
        end
    end

    describe "DELETE #destroy" do
        subject {Proc.new { delete :destroy, params: {id: id} }}
        let!(:task) { create(:task) }
        context "該当するタスクが存在する場合" do
            let(:id) { task.id }
            it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 302
            
            it "タスクが削除されること" do
                expect { subject.call }.to change(Task, :count).by(-1)
                expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
            end
            
            it "タスク一覧画面へリダイレクトされ、フラッシュメッセージが表示されること" do
                subject.call
                expect(response).to redirect_to "/"
                expect(flash[:notice]).to match(/^タスクを削除しました！$/)
            end
        end
        context "該当するタスクが存在しない場合" do
            let(:id) { Task.last.id + 1 }
            it_behaves_like "想定エラーが発生すること", ActiveRecord::RecordNotFound
        end
    end

end
