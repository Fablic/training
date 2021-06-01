require 'rails_helper'

RSpec.describe TaskLabelAttachment, type: :model do
  let(:attachment) { create(:task_label_attachment) }

  describe 'Uniqueness validation' do
    let(:user) { create(:user) }
    let(:task) { create(:task, user: user) }
    let(:label) { create(:label, user: user) }

    before do
      create(:task_label_attachment, task: task, label: label)
    end

    it 'invalidates because of the uniqueness constraint' do
      instance = described_class.new(task: task, label: label)
      expect(instance).not_to be_valid
      expect(instance.errors.messages[:label_id]).to eq ['The specified task and label have already been associated']
    end
  end

  describe '#check_ownership' do
    it 'does nothing when the record is valid' do
      expect(attachment).to be_valid
      expect(attachment.errors.messages).not_to include(:base)
    end

    it 'adds an error message because of the different user_id' do
      attachment.task.user = create(:user)
      expect(attachment).not_to be_valid
      expect(attachment.errors.messages[:base]).to eq ['The associated task and label must have a common user']
    end
  end
end
