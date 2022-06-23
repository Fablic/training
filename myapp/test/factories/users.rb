FactoryBot.define do
	factory :user do
		email { 'hoge@gmail.com' }
		password { 'password' }
		name { 'hoge' }
	end

end