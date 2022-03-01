require 'rails_helper'

RSpec.describe Task, type: :model do
  
  before do
    FactoryBot.create(:board)
    @status1 = FactoryBot.create(:status, sort: 2)
    @status2 = FactoryBot.create(:status, sort: 3)
    @status3 = FactoryBot.create(:status, sort: 1)

    FactoryBot.create(:priority, sort: 1)
    priority2 = FactoryBot.create(:priority, sort: 3)
    FactoryBot.create(:priority, sort: 2)

    @task1 = FactoryBot.create(:task, priority: priority2, status: @status2)

    FactoryBot.create(:status_step, from_status: @status3, to_status: @status1)
    FactoryBot.create(:status_step, from_status: @status1, to_status: @status3)
    FactoryBot.create(:status_step, from_status: @status1, to_status: @status2)
    FactoryBot.create(:status_step, from_status: @status2, to_status: @status1)
  end

  it 'skip status validation when create' do
    subject = FactoryBot.create(:task, status: @status2)
    expect(subject).to be_valid
  end

  it 'valid status change' do
    @task1.status = @status1
    expect(@task1).to be_valid
  end

  it 'invalid status change' do
    @task1.status = @status3
    expect(@task1).to_not be_valid
  end

  it 'valid priority and status' do
    subject = FactoryBot.create(:task)
    expect(subject).to be_valid
  end

  it 'invalid priority' do
    @task1.priority_id = 9999
    expect(@task1).to_not be_valid
  end

  it 'invalid title' do
    @task1.title = ''
    expect(@task1).to_not be_valid
  end
end
