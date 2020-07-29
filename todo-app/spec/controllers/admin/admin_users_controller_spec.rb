# frozen_string_literal: true

require 'rails_helper'

describe Admin::UsersController, type: :controller do
  render_views

  before do
    @app_user = FactoryBot.create(:admin_user)
    FactoryBot.create(:task, name: 'task1', app_user: @app_user)
    FactoryBot.create(:task, name: 'task2', app_user: @app_user)

    session[:current_user_id] = @app_user.id

    @standard_user = FactoryBot.create(:app_user)
    FactoryBot.create(:task, name: 'task3', app_user: @standard_user)
  end

  it 'render index template' do
    get :index
    expect(response).to render_template :index

    expect(response.body).to include('user1')
    expect(response.body).to include('admin')
  end

  it 'Display new task screen' do
    get :new
    expect(response.status).to eq 200
  end

  it 'Create new user' do
    post :create, params: { app_user: { name: '新しいユーザ', password: 'changeme', password_confirm: 'changeme' } }
    expect(response.status).to eq 302

    expect(AppUser.all.count).to eq 3
  end

  it 'Create new user password un match' do
    post :create, params: { app_user: { name: '新しいユーザ', password: 'changeme', password_confirm: 'not changeme' } }
    expect(response).to render_template :new

    expect(AppUser.all.count).to eq 2
  end

  it 'Delete user success' do
    delete :destroy, params: { id: @standard_user[:id] }, xhr: true
    expect(response.status).to eq 200

    expect(AppUser.all.count).to eq 1
  end

  it 'Delete admin user fail' do
    delete :destroy, params: { id: @app_user[:id] }, xhr: true
    expect(response.status).to eq 403

    expect(AppUser.all.count).to eq 2
  end

  it 'Suspend User' do
    post :suspend, params: { user_id: @app_user[:id] }, xhr: true
    expect(response.status).to eq 200

    expect(AppUser.find(@app_user[:id]).suspended?).to be_truthy

    post :suspend, params: { user_id: @app_user[:id] }, xhr: true
    expect(response.status).to eq 200

    expect(AppUser.find(@app_user[:id]).suspended?).to be_falsey
  end
end
