require 'rails_helper'

RSpec.describe LabelsController, type: :request do
  let(:user) { create(:user) }
  let(:label) { create(:label, user: user) }

  before do
    login_as user
  end

  describe 'POST /labels' do
    it 'lets a user create a label' do
      expect { post '/labels', params: { label: { name: 'A', color: '#f0f' } } }.to change { Label.count }.by(1)
      label = Label.find_by(name: 'A')
      expect(label).to be_valid
      expect(label.user).to eq user
      expect(label.color).to eq '#f0f'
    end
  end

  describe 'PATCH /labels/:id' do
    it 'lets a user edit a label' do
      expect { patch "/labels/#{label.id}", params: { label: { name: 'Changed!' } } }
        .to change { label.reload.name }.to('Changed!')
    end

    it "disallows a user to edit another user's label" do
      another_user = create(:user)
      another_label = create(:label, user: another_user)
      expect { patch "/labels/#{another_label.id}", params: { label: { name: 'Changed!' } } }
        .to not_change { label.reload.name }.and raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'DELETE /labels/:id' do
    it 'lets a user delete a label' do
      label_id = label.id
      expect { delete "/labels/#{label.id}" }.to change { Label.count }.by(-1)
      expect(Label.exists?(label_id)).to be false
    end

    it "disallows a user to delete another user's label" do
      another_user = create(:user)
      another_label = create(:label, user: another_user)
      expect { delete "/labels/#{another_label.id}" }.to not_change { Label.count }.and raise_error ActiveRecord::RecordNotFound
      expect(another_label).to be_persisted
    end
  end
end
