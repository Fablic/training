require 'rails_helper'

RSpec.describe Task, type: :model do

    MSG_INVALID_INPUT = 'を入力してください'

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
            max_num = 50

            context "タイトルが#{ max_num }文字の場合" do
                let(:num) { max_num }

                it 'バリデーションエラーにならないこと' do
                    expect(task.valid?).to eq true
                end
            end
            context "タイトルが#{ max_num+1 }文字以上の場合" do
                let(:num) { max_num+1 }

                it 'バリデーションエラーになること' do
                    expect(task.valid?).to eq false
                end
                it 'エラーメッセージが表示されること' do
                    task.valid?
                    expect(task.errors.messages[:title]).to include "は#{ max_num }文字以内で入力してください"
                end
            end
        end
        context 'タイトルに正常な値が入力されていない場合' do
            context 'タイトルが空の場合' do
                let(:title) { '' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:title, MSG_INVALID_INPUT
            end
            context 'タイトルが空白の場合' do
                let(:title) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:title, MSG_INVALID_INPUT
            end
            context 'タイトルがnilの場合' do
                let(:title) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:title, MSG_INVALID_INPUT
            end
        end
    end
  
    describe 'description' do
        let(:task) { build(:task, description: description) }

        context '説明に正常な値が入力されている場合' do
            let(:description) { 'あ' * num }
            max_num = 255

            context "説明が#{ max_num }文字の場合" do    
                let(:num) { max_num }

                it 'バリデーションエラーにならないこと' do
                    expect(task.valid?).to eq true
                end
            end
            context "説明が#{ max_num+1 }文字以上の場合" do
                let(:num) { max_num+1 }
        
                it 'バリデーションエラーになること' do
                    expect(task.valid?).to eq false
                end
                it 'エラーメッセージが表示されること' do
                    task.valid?
                    expect(task.errors.messages[:description]).to include "は#{ max_num }文字以内で入力してください"
                end
            end
        end
        context '説明に正常な値が入力されていない場合' do
            context '説明が空の場合' do
                let(:description) { '' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:description, MSG_INVALID_INPUT
            end
            context '説明が空白の場合' do
                let(:description) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:description, MSG_INVALID_INPUT
            end
            context '説明がnilの場合' do
                let(:description) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:description, MSG_INVALID_INPUT
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
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:termination_at, MSG_INVALID_INPUT
            end
            context '終了期日が空白の場合' do
                let(:termination_at) { ' ' }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:termination_at, MSG_INVALID_INPUT
            end
            context '終了期日がnilの場合' do
                let(:termination_at) { nil }
                it_behaves_like 'バリデーションエラーとなり、想定するメッセージが表示されること',:termination_at, MSG_INVALID_INPUT
            end
        end
    end
end
