FactoryBot.define do
	factory :user do
		email { 'hoge@example.com' }
		password { 'password' }
		name { 'hoge' }
	end

end