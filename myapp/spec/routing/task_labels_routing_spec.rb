require 'rails_helper'

RSpec.describe TaskLabelsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/task_labels/new').to route_to('task_labels#new')
    end
  end
end
