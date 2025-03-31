require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  subject { User.new(name: "User 1", username: "user1", password: "12345678") }

  describe "GET /login" do
    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "redirects to the tasks page" do
        subject.save
        post "/login", params: { username: subject.username, password: subject.password }
        expect(response).to redirect_to(tasks_path)
      end
    end

    context "with invalid credentials" do
      it "renders the login page" do
        post "/login", params: { username: subject.username, password: "wrongpassword" }
        expect(response).to have_http_status(422)
        expect(response.body).to include(I18n.t("msg_invalid_username_or_password"))
      end
    end
  end
  
  describe "DELETE /logout" do
    it "redirects to the login page" do
      delete "/logout"
      expect(response).to redirect_to(login_path)
    end
  end
end
