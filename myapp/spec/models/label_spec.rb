require 'rails_helper'

RSpec.describe Label, type: :model do
  subject(:instance) { label }
  subject(:error_messages) { label.tap(&:validate).errors.messages }

  let(:user) { create(:user) }
  let(:label) { create(:label, user: user) }

  describe '#name' do
    context 'when the name is nil' do
      before { label.name = nil }

      it { expect(instance).not_to be_valid }
      it { expect(error_messages[:name]).to eq ['Name must be filled in'] }
    end

    context 'when the name is the same as another label' do
      before do
        other_label = create(:label, user: user)
        label.name = other_label.name
      end

      it { expect(instance).not_to be_valid }
      it { expect(error_messages[:name]).to eq ['The same name has already been taken'] }
    end

    context 'when the name is the same as another, but its owner is different' do
      let(:another) { create(:user) }

      before do
        another = create(:label)
        label.name = another.name
      end

      it { expect(instance).to be_valid }
      it { expect(error_messages).to be_empty }
    end
  end

  describe '#color' do
    shared_examples :with_valid_color do |val|
      before do
        label.color = val
      end

      it { expect(instance).to be_valid }
      it { expect(error_messages).to be_empty }
    end

    shared_examples :with_invalid_color do |val|
      before do
        label.color = val
      end

      it { expect(instance).not_to be_valid }
      it { expect(error_messages[:color]).to eq ['Only hexadecimal notation, such as #ef00b3, is supported'] }
    end

    it_behaves_like :with_valid_color, '#000'
    it_behaves_like :with_valid_color, '#fff'
    it_behaves_like :with_valid_color, '#324f'
    it_behaves_like :with_valid_color, '#ff9900'
    it_behaves_like :with_valid_color, '#fbdbdbaa'
    it_behaves_like :with_valid_color, '#00aa1189'
    it_behaves_like :with_invalid_color, 'rgb(0, 0, 0)'
    it_behaves_like :with_invalid_color, '#mmxxzz'
    it_behaves_like :with_invalid_color, '#nmo'
    it_behaves_like :with_invalid_color, 'hsla(0, 0, 0, 1)'

    context 'when the color is not present' do
      before do
        label.color = nil
      end

      it { expect(instance).not_to be_valid }
      it { expect(error_messages[:color]).to eq ['Color is required'] }
    end
  end
end
