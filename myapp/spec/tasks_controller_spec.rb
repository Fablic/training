require 'rails_helper'

RSpec.describe TasksController, type: :controller do

    before do
        @task = Task.create(
            user_id: 0,
            title: "test_title",
            description: "test_description",
            termination_at: '2022-01-01 00:00:00',
            priority: 0,
            status: 0,
        )
    end

    shared_examples_for "returns http success" do
        it { subject.call; expect(response).to have_http_status(:success) }
    end

    shared_examples_for "returns http redirect" do
        it { subject.call; expect(response).to have_http_status("302") }
    end

    describe "GET #index" do
        subject {Proc.new { get :index }}
        it_behaves_like "returns http success"
    end

    describe "GET #new" do
        subject {Proc.new { get :new }}
        it_behaves_like "returns http success"
    end

    describe "GET #show" do
        context "該当するタスクが存在する場合" do
            context "有効なパラメータの場合" do
                subject {Proc.new { get :show, params: { id: @task.id } }}
                it_behaves_like "returns http success"
            end
            context "無効なパラメータの場合" do
            end
        end
        context "該当するタスクが存在しない場合" do
        end
    end

    describe "GET #edit" do
        context "該当するタスクが存在する場合" do
            context "有効なパラメータの場合" do
                subject {Proc.new { get :edit, params: { id: @task.id } }}
                it_behaves_like "returns http success"
            end
            context "無効なパラメータの場合" do
            end
        end
        context "該当するタスクが存在しない場合" do
        end
    end

    describe "POST #create" do
        context "有効なパラメータの場合" do
            subject (:create_task){Proc.new { post :create, params: { task: {
                user_id: 1,
                title: "test_title2",
                description: "test_description2",
                termination_at: '2022-01-01 00:00:00',
                priority: 0,
                status: 0
            }} }}
            it_behaves_like "returns http redirect"

            it "create task successfully " do
                expect { create_task.call }.to change(Task, :count).by(1)
                expect(Task.find(Task.last.id).title).to eq("test_title2")
            end

            it "redirects and displays flush message." do
                create_task.call
                expect(response).to redirect_to "/#{Task.last.id}"
                expect(flash[:notice]).to match(/^タスクを作成しました。$/)
            end
        end
        context "無効なパラメータの場合" do
        end
    end

    describe "PATCH #update" do
        context "該当するタスクが存在する場合" do
            context "有効なパラメータの場合" do
                subject (:update_task){Proc.new { patch :update, params: {id: @task.id, task: {title: "updated_task"}} }}
                it_behaves_like "returns http redirect"
                
                it "updates a task" do
                    update_task.call
                    expect(@task.reload.title).to eq "updated_task"
                end

                it "redirects and displays flush message" do
                    update_task.call
                    expect(response).to redirect_to "/#{@task.id}"
                    expect(flash[:notice]).to match(/^タスクを更新しました。$/)
                end
            end
            context "無効なパラメータの場合" do
            end
        end
        context "該当するタスクが存在しない場合" do
        end
    end

    describe "DELETE #destroy" do
        context "該当するタスクが存在する場合" do
            subject (:destroy_task){Proc.new { delete :destroy, params: {id: @task.id} }}
            it_behaves_like "returns http redirect"
            
            it "deletes a task" do
                expect { destroy_task.call }.to change(Task, :count).by(-1)
                expect { Task.find(@task.id) }.to raise_error(ActiveRecord::RecordNotFound)
            end
            
            it "redirects and displays flush message" do
                destroy_task.call
                expect(response).to redirect_to "/"
                expect(flash[:notice]).to match(/^タスクを削除しました。$/)
            end
        end
        context "該当するタスクが存在しない場合" do
        end
    end

end
