# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLabelsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/task_labels/new').to route_to('task_labels#new')
    end

    it 'routes to #attach_labels' do
      expect(post: '/task_labels/attach_labels').to route_to('task_labels#attach_labels')
    end
  end
end
