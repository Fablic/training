# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  let(:task) { Task.new(name: name, description: description, status: status, start_at: start_at, due_date_at: due_date_at) }
  let(:name) { '最初のタスク' }
  let(:description) { '説明文' }
  let(:status) { :not_started }
  let(:start_at) { '2021/09/01 10:00' }
  let(:due_date_at) { '2021/09/02 11:00' }

  describe 'バリデーションのテスト' do
    subject { task }

    context '全項目入力' do
      it { is_expected.to be_valid }
    end

    describe 'nameカラム' do
      context '空欄' do
        let(:name) { '' }

        it { is_expected.not_to be_valid }
      end

      context '50文字以内' do
        let(:name) { 'a' * 50 }

        it { is_expected.to be_valid }
      end

      context '51文字以上' do
        let(:name) { 'a' * 51 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'descriptionカラム' do
      context '空欄' do
        let(:description) { '' }

        it { is_expected.to be_valid }
      end

      context '2000文字以内' do
        let(:description) { 'a' * 2000 }

        it { is_expected.to be_valid }
      end

      context '2000文字以上' do
        let(:description) { 'a' * 2001 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'statusカラム' do
      context '許容される値 not_started' do
        let(:status) { :not_started }

        it { is_expected.to be_valid }
      end

      context '許容される値 wip' do
        let(:status) { :wip }

        it { is_expected.to be_valid }
      end

      context '許容される値 completed' do
        let(:status) { :completed }

        it { is_expected.to be_valid }
      end

      context '許容されない値' do
        let(:status) { :pending }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'start_atカラム' do
      context '空欄でないこと' do
        let(:start_at) { '' }

        it { is_expected.not_to be_valid }
      end

      context '日付のフォーマットが不正' do
        let(:start_at) { '2021年09ー01 10:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない日付' do
        let(:start_at) { '2021/02/99 10:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない時間' do
        let(:start_at) { '2021/09/01 10:99' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'due_date_atカラム' do
      context '空欄でないこと' do
        let(:due_date_at) { '' }

        it { is_expected.not_to be_valid }
      end

      context '日付のフォーマットが不正' do
        let(:due_date_at) { '2021年09ー02 11:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない日付' do
        let(:due_date_at) { '2021/09/99 11:00' }

        it { is_expected.not_to be_valid }
      end

      context '存在しない時間' do
        let(:due_date_at) { '2021/09/02 11:99' }

        it { is_expected.not_to be_valid }
      end
    end

    describe '複合' do
      context 'start_at > due_date_atでないこと' do
        let(:start_at) { '2021/09/01 10:00' }
        let(:due_date_at) { '2021/08/31 10:00' }

        it { is_expected.not_to be_valid }
      end
    end
  end

  describe 'save_task_and_label' do
    subject(:save_task_and_label) { Task.save_task_and_label(task, 'label,label2') }

    let!(:user) { create(:user, name: 'HanakoRakuten', password: 'hanakopass', privilege: :user) }
    let!(:task) { Task.new(name: 'task', description: '', status: :wip, start_at: '2021-09-01 10:00', due_date_at: '2021-09-02 10:00', user_id: user.id) }

    context '例外が発生しない場合' do
      it '正常にDB更新されること' do
        # 実行
        expect(save_task_and_label).to eq true

        result_task = Task.find(task.id)
        result_task_label_ids = TaskLabel.where(task_id: task.id).pluck('label_id')
        result_label_names = Label.where(id: result_task_label_ids).pluck('name')
        expect(result_task.name).to eq 'task'
        expect(result_label_names).to eq %w[label label2]
      end
    end

    context 'saveで例外が発生した場合' do
      before do
        # 例外を発生させる
        allow(Task).to receive(:exec_save_with_label).and_raise StandardError
      end

      it 'ロールバックが実行されること' do
        # 実行
        expect(save_task_and_label).to eq false
        expect(task.id).to eq nil
      end
    end
  end

  describe 'update_task_and_label' do
    subject(:update_task_and_label) { Task.update_task_and_label(task, 'label,label2') }

    let!(:user) { create(:user, name: 'HanakoRakuten', password: 'hanakopass', privilege: :user) }
    let!(:task) { create(:task, name: 'task', description: '', status: :wip, start_at: '2021-09-01 10:00', due_date_at: '2021-09-02 10:00', user_id: user.id) }
    let!(:label) { Label.create(name: 'label') }

    before do
      TaskLabel.create(task_id: task.id, label_id: label.id)
    end

    context 'DB更新が正常に実行できた場合' do
      it '正常に更新されること' do
        # 実行
        expect(update_task_and_label).to eq true

        result_task = Task.find(task.id)
        result_task_label_ids = TaskLabel.where(task_id: task.id).pluck('label_id')
        result_label_names = Label.where(id: result_task_label_ids).pluck('name')
        expect(result_task.name).to eq 'task'
        expect(result_label_names).to eq %w[label label2]
      end
    end

    context 'saveで例外が発生した場合' do
      before do
        # 例外を発生させる
        allow(task).to receive(:save).and_raise StandardError
      end

      it 'ロールバックが実行されること' do
        # 実行
        expect(update_task_and_label).to eq false

        result_task = Task.find(task.id)
        result_task_label_ids = TaskLabel.where(task_id: task.id).pluck('label_id')
        result_label_names = Label.where(id: result_task_label_ids).pluck('name')
        expect(result_task.name).to eq 'task'
        expect(result_label_names).to eq ['label']
      end
    end
  end
end
