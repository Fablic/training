require 'rails_helper'

RSpec.describe "session/new.html.erb", type: :view do
  <body class="background">
  <div class="login-form-row">
    <div class="offset-column">
      <div class="login-card">
        <div class="login-title">
          <b>
            <%= t('pages.login_page.login') %>
          </b>
        </div>
        <div class="login-card-body">
          <%= form_with url: '/login', method: "POST", local: true do |f| %>
              <%= f.label t('attributes.model.task.username') %>
              <%= f.text_field :username, autofocus: true %>
            </div>
            <div class="input-field">
              <%= f.label t('attributes.model.task.password') %>
              <%= f.password_field :password %>
            </div>
            <div class="submit-button">
              <%= f.submit "Login" , class: "btn btn-primary" %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
  </div>
</body>

end
