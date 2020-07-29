# frozen_string_literal: true

require 'rails_helper'

describe Admin::TopController, type: :controller do
  render_views

  it 'Display index screen' do
    @app_user = FactoryBot.create(:admin_user)
    session[:current_user_id] = @app_user.id

    get :index
    expect(response).to render_template :index
  end

  it 'Forbidden display admin screen from standard user' do
    @app_user = FactoryBot.create(:app_user)
    session[:current_user_id] = @app_user.id

    get :index
    expect(response.status).to eq 403
  end
end
