require 'rails_helper'

RSpec.describe Task, type: :model do

    MSG_NO_VALUE = 'を入力してください'
    MSG_INVALID_VALUE = 'に不正な値が入力されています'
    TITLE_MAX_LENGHT = 50
    DESCRIPTION_MAX_LENGHT = 255

    shared_examples_for 'バリデーションエラーとなり、想定するメッセージが表示されること' do | column, message|
        it { expect(task.valid?).to eq false
            task.valid?
            expect(task.errors.messages[column]).to include message
        }
    end

    describe 'title' do
        let(:task) { build(:task, title: title) }

        context 'タイトルに正常な値が入力されている場合' do
            let(:title) { 'あ' * num }

            context "タイトルが#{ TITLE_MAX_LENGHT }文字の場合" do
                let(:num) { TITLE_MAX_LENGHT }

                it 'バリデーションエラーにならないこと' do
                    expect(task.valid?).to eq true
                end
            end
            context "タイトルが#{ TITLE_MAX_LENGHT+1 }文字以上の場合" do
                let(:num) { TITLE_MAX_LENGHT+1 }

                it 'バリデーションエラーになること' do
                    expect(task.valid?).to eq false
                end
                it 'エラーメッセージが表示されること' do
                    task.valid?
                    expect(task.errors.messages[:title]).to include "は#{ TITLE_MAX_LENGHT }文字以内で入力してください"
                end
            end
        end
        context 'タイトルに正常な値が入力されていない場合' do
            context 'タイトルが空の場合' do
                let(:title) { '' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:title, MSG_NO_VALUE
            end
            context 'タイトルが空白の場合' do
                let(:title) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:title, MSG_NO_VALUE
            end
            context 'タイトルがnilの場合' do
                let(:title) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:title, MSG_NO_VALUE
            end
        end
    end
  
    describe 'description' do
        let(:task) { build(:task, description: description) }

        context '説明に正常な値が入力されている場合' do
            let(:description) { 'あ' * num }

            context "説明が#{ DESCRIPTION_MAX_LENGHT }文字の場合" do    
                let(:num) { DESCRIPTION_MAX_LENGHT }

                it 'バリデーションエラーにならないこと' do
                    expect(task.valid?).to eq true
                end
            end
            context "説明が#{ DESCRIPTION_MAX_LENGHT+1 }文字以上の場合" do
                let(:num) { DESCRIPTION_MAX_LENGHT+1 }
        
                it 'バリデーションエラーになること' do
                    expect(task.valid?).to eq false
                end
                it 'エラーメッセージが表示されること' do
                    task.valid?
                    expect(task.errors.messages[:description]).to include "は#{ DESCRIPTION_MAX_LENGHT }文字以内で入力してください"
                end
            end
        end
        context '説明に正常な値が入力されていない場合' do
            context '説明が空の場合' do
                let(:description) { '' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:description, MSG_NO_VALUE
            end
            context '説明が空白の場合' do
                let(:description) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:description, MSG_NO_VALUE
            end
            context '説明がnilの場合' do
                let(:description) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:description, MSG_NO_VALUE
            end
        end
    end
  
    describe 'termination_at' do
        let(:task) { build(:task, termination_at: termination_at) }

        context '終了期日に正常な値が入力されている場合' do
            context '終了期日が現在日時よりも後の日付である場合' do
                let(:termination_at) { Time.now + 1 }
                it 'バリデーションエラーにならないこと' do
                    expect(task.valid?).to eq true
                end
            end
            context '終了期日が現在日時以前の日付である場合' do
                let(:termination_at) { Time.now }

                it 'バリデーションエラーになること' do
                    expect(task.valid?).to eq false
                end
                it 'エラーメッセージが表示されること' do
                    task.valid?
                    expect(task.errors.messages[:termination_at]).to include 'は現在時刻より後の日付を指定してください'
                end
            end
        end
        context "終了期日に正常な値が入力されていない場合" do
            context '終了期日が空の場合' do
                let(:termination_at) { '' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:termination_at, MSG_NO_VALUE
            end
            context '終了期日が空白の場合' do
                let(:termination_at) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:termination_at, MSG_NO_VALUE
            end
            context '終了期日がnilの場合' do
                let(:termination_at) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:termination_at, MSG_NO_VALUE
            end
        end
    end

    describe 'priority' do
        let(:task) { build(:task, priority: priority) }

        context '優先度に正常な値が入力されている場合' do
            context 'Enumで定義されている値の場合' do
                let(:priority) { Task.priorities.key(0) }

                it 'バリデーションエラーにならないこと' do
                    expect(task.valid?).to eq true
                end
            end
            context 'Enumで定義されていない値の場合' do
                let(:priority) { "unknown_priority" }
                
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:priority, MSG_INVALID_VALUE
            end
        end
        context '優先度に正常な値が入力されていない場合' do
            context '優先度が空の場合' do
                let(:priority) { '' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:priority, MSG_NO_VALUE
            end
            context '優先度が空白の場合' do
                let(:priority) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:priority, MSG_NO_VALUE
            end
            context '優先度がnilの場合' do
                let(:priority) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:priority, MSG_NO_VALUE
            end
        end
    end

    describe 'status' do
        let(:task) { build(:task, status: status) }
        context 'ステータスに正常な値が入力されている場合' do

            context 'Enumで定義されている値の場合' do
                let(:status) { Task.statuses.key(0) }

                it 'バリデーションエラーにならないこと' do
                    expect(task.valid?).to eq true
                end
            end
            context 'Enumで定義されていない値の場合' do
                let(:status) { "unknown_status" }

                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:status, MSG_INVALID_VALUE
            end
        end
        context 'ステータスに正常な値が入力されていない場合' do
            context 'ステータスが空の場合' do
                let(:status) { '' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:status, MSG_NO_VALUE
            end
            context 'ステータスが空白の場合' do
                let(:status) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:status, MSG_NO_VALUE
            end
            context 'ステータスがnilの場合' do
                let(:status) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:status, MSG_NO_VALUE
            end
        end
    end
end
