require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  describe "DELETE /admin/users/:id" do
    let!(:admin) { User.create!(email: 'admin@example.com', password: 'password', admin: true, name: "Admin") }

    context "when trying to delete the last admin" do
      before do
        # Manually sign in by setting the session
        post login_path, params: { session: { email: admin.email, password: admin.password } }
      end

      it "does not allow deleting the last admin" do
        expect {
          delete admin_user_path(admin)
        }.not_to change(User, :count)

        expect(response).to redirect_to(admin_users_path)
        follow_redirect!
        expect(response.body).to include("最後の管理者は削除できません。")
      end
    end
  end
end