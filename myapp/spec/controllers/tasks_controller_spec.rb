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
        it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200
    end

    describe "GET #new" do
        subject {Proc.new { get :new }}
        it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと", 200
    end

    describe "GET #show" do
        subject {Proc.new { get :show, params: { id: id } }}
        context "該当するタスクが存在する場合" do
            let(:task) { create(:task) }
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
            let(:id) { Task.last.id + 1  }
            it_behaves_like "想定エラーが発生すること", ActiveRecord::RecordNotFound
        end
    end

    describe "GET #edit" do
        subject {Proc.new { get :edit, params: { id: id } }}
        context "該当するタスクが存在する場合" do
            let(:task) { create(:task) }
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
            let(:task) { {
                user_id: 1,
                title: "test_title_02",
                description: "test_description_02",
                termination_at: '2022-01-01 00:00:00',
                priority: 0,
                status: 0
            } }
            it_behaves_like "レスポンス(HTTPステータスコード)が正しいこと",302

            it "タスクが作成されること" do
                expect { subject.call }.to change(Task, :count).by(1)
                expect(Task.find(Task.last.id).title).to eq("test_title_02")
            end

            it "作成したタスク詳細画面へリダイレクトされ、フラッシュメッセージが表示されること" do
                subject.call
                expect(response).to redirect_to "/#{Task.last.id}"
                expect(flash[:notice]).to match(/^タスクを作成しました！$/)
            end
        end
        context "無効なパラメータの場合" do
            let(:task) { {
                user_id: 1,
                description: "test_description_02",
                termination_at: '2022-01-01 00:00:00',
                priority: 0,
                status: 0
            } }
            it_behaves_like "想定エラーが発生すること", ActiveRecord::NotNullViolation
        end
    end

    describe "PATCH #update" do
        subject {Proc.new { patch :update, params: {id: id, task: {title: "updated_task"}} }}
        context "該当するタスクが存在する場合" do
            let(:task) { create(:task) }
            context "有効なパラメータの場合" do
                let(:id) { task.id }
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
                let(:id) { nil }
                it_behaves_like "想定エラーが発生すること", ActionController::UrlGenerationError
            end
        end
        context "該当するタスクが存在しない場合" do
            let(:id) { Task.last.id + 1 }
            it_behaves_like "想定エラーが発生すること", ActiveRecord::RecordNotFound
        end
    end

    describe "DELETE #destroy" do
        subject {Proc.new { delete :destroy, params: {id: id} }}
        context "該当するタスクが存在する場合" do
            let!(:task) { create(:task) }
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
