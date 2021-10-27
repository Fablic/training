# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  let(:user) { create(:generic_user) }
  let(:task) {
    Task.new(name: name, description: description, status: status, started_at: started_at, finished_at: finished_at, created_by: created_by, priority: priority)
  }
  let(:created_by) { user.id }
  let(:name) { 'new_task' }
  let(:priority) { 4 }
  let(:description) { 'new_task_description' }
  let(:status) { 'pending' }
  let(:started_at) { 2.days.from_now.strftime('%Y-%m-%d') }
  let(:finished_at) { 5.days.from_now.strftime('%Y-%m-%d') }

  describe 'Normal case' do
    subject { task }

    context 'all values filled' do
      it { is_expected.to be_valid }
    end

    context 'blank desc' do
      let(:description) { '' }

      it { is_expected.to be_valid }
    end

    context 'blank started_at' do
      let(:started_at) { '' }

      it { is_expected.to be_valid }
    end
  end

  describe 'validation' do

    describe 'created_by' do
      subject { task }

      context 'blank' do
        let(:created_by) { '' }
        it { is_expected.not_to be_valid }
      end

      context 'user does not exist' do
        let(:created_by) { user.id + 12323 }
        
        it { is_expected.not_to be_valid }

      end
    end

    describe 'name' do
      subject { task }

      context 'blank' do
        let(:name) { '' }

        it { is_expected.not_to be_valid }
      end

      context '<= 75 len' do
        let(:name) { 'a' * 75 }

        it { is_expected.to be_valid }
      end

      context '>75 len' do
        let(:name) { 'a' * 76 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'description' do
      subject { task }

      context '<=1000 len' do
        let(:description) { 'a' * 1000 }

        it { is_expected.to be_valid }
      end

      context '>1000 len' do
        let(:description) { 'a' * 1001 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'status' do
      subject { task }

      context 'valid values pending' do
        let(:status) { 'pending' }

        it { is_expected.to be_valid }
      end

      context 'valid values started' do
        let(:status) { 'started' }

        it { is_expected.to be_valid }
      end

      context 'valid values finished' do
        let(:status) { 'finished' }

        it { is_expected.to be_valid }
      end

    end

    describe 'started_at column' do
      subject { task }

      context 'invalid date' do
        let(:started_at) { '2021年09ー01 10:00' }

        it { is_expected.not_to be_valid }
      end

      context 'impossible date' do
        let(:started_at) { '2021/02/31' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'finished_at col' do
      subject { task }

      context 'blank' do
        let(:finished_at) { '' }

        it { is_expected.not_to be_valid }
      end

      context 'invalid date' do
        let(:finished_at) { '2021年09ー02 11:00' }

        it { is_expected.not_to be_valid }
      end

      context 'impossible date' do
        let(:finished_at) { '2021/02/31' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'priority' do
      subject { task }

      context '<1' do
        let(:priority) { -1 }

        it { is_expected.not_to be_valid }
      end
      context '==0' do
        let(:priority) { 0 }

        it { is_expected.not_to be_valid }
      end
      context '>10' do
        let(:priority) { 11 }

        it { is_expected.not_to be_valid }
      end

      context 'string' do
        let(:priority) { 'dsfef' }

        it { is_expected.not_to be_valid }
      end

    end

    describe 'finished earlier than start' do
      subject { task }

      context 'start_at > due_date_at' do
        let(:started_at) { '2021/03/01' }
        let(:finished_at) { '2021/02/01' }

        it { is_expected.not_to be_valid }
      end
    end

  
  end
end
