require 'rails_helper'

RSpec.describe 'Task', type: :model do

  describe "validation" do
    context "[Normal] valid parameters" do
      let(:task) { Task.new(name: 'sample_task',
        description: 'hoge fuga',
        deadline_at: '2023-01-01T00:00')}

      it "behaves like" do
        task.valid?
        expect(task.errors.count).to eq 0
      end
    end

    context "[Exceptional] invalid name" do
      let(:task) { Task.new(name: '',
                            description: 'hoge fuga',
                            deadline_at: '2023-01-01T00:00')}

      it "behaves like" do
        task.valid?
        expect(task.errors.count).to eq 1
        expect(task.errors[:name].present?).to eq true
      end
    end
  end

end
